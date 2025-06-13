#!/bin/bash
set -u

# Settings variables
# APPS array by its name (ex: "App Store".app)
APPS=("Launchpad"
      "Google Chrome" "Safari" "Surfshark"
      "Discord" "Mail" "Telegram" "Figma"
      "Bruno" "Transmit" "Visual Studio Code" "WebStorm" "Windsurf" "Docker"
      "Termius" "iTerm" "Activity Monitor" "Screenshot"  "Reminders" "Calculator" "System Settings"
)
# FOLDERS array by its path name and view (ex: "$HOME/Documents" "Documents" "list")
FOLDERS=("('$HOME/Documents' 'Documents' 'list')"
         "('$HOME/Downloads' 'Downloads' 'list')"
         "('/Applications/Utilities' 'Utilities' 'list')"
         "('$HOME/Web' 'Web' 'list')"
         "('$HOME/Work' 'Work' 'list')"
)

# Color variables
GREEN=$(tput setab 0)$(tput setaf 2)$(tput bold)
RED=$(tput setab 0)$(tput setaf 1)$(tput bold)
YELLOW=$(tput setab 0)$(tput setaf 3)$(tput bold)
RESET=$(tput sgr0)

# Message colored green
function success(){
    echo "${GREEN} ✓ ${1} ${RESET}"
}

# Message colored red
function error(){
    echo "${RED} ⚠ ${1} ${RESET}"
}

# Message colored yellow
function alert(){
    echo "${YELLOW} � ${1} ${RESET}"
}

# Abort session
function abort() {
    printf "%s\n" "$@"
    exit 1
}

# Check if bash is interpretable
if [ -z "${BASH_VERSION:-}" ]; then
    abort "Bash is required to interpret this script."
fi

# Install brew dockutil if not installed
if [ -x "$(command -v dockutil)" ]; then
  sleep 0
else
  brew install dockutil
fi

# Check if directory exist
function check_directory_exists(){
    [ -d "${1}" ] && return 0
}

# Remove all dock icons
function dockutil_remove_all(){
    dockutil --remove all --no-restart
}

# Add folder icon to dock
# ex: dockutil_add_app "$HOME/Documents" "Documents" "list"
function dockutil_add_folder(){
    if check_directory_exists "${1}"; then
        # options: PATH LABEL POSITION VIEW
        dockutil --add "${1}" --label "${2}" --position "${3}" --view "${4}" --display "folder" --sort "name" --no-restart &> /dev/null
        echo -e "Folder added: ${2} (\"${1}\")"
    else
        error "Folder not exists: ${2} (\"${1}\")"
    fi
}

# Return app path by its name
# ex: dockutil_app_path Launchpad.app
# returns: /System/Applications/Launchpad.app
function dockutil_return_app_path(){
    local OTHER="/Applications/${1}"
    local SYSTEM="/System/Applications/${1}"
    local UTILITIES="/System/Applications/Utilities/${1}"
    local PREBOOT="/System/Volumes/Preboot/Cryptexes/App/System/Applications/${1}"
    if check_directory_exists "${SYSTEM}"; then
        echo "${SYSTEM}"
    elif check_directory_exists "${UTILITIES}"; then
        echo "${UTILITIES}"
    elif check_directory_exists "${PREBOOT}"; then
        echo "${PREBOOT}"
    elif check_directory_exists "${OTHER}"; then
        echo "${OTHER}"
    else
        echo "${@}"
    fi
}

# Add app icon to dock
# ex: dockutil_add_app Launchpad 1
function dockutil_add_app(){
    # shellcheck disable=SC2155
    local APP="$(dockutil_return_app_path "${1}.app")"
    # shellcheck disable=SC2155
    local LABEL=$(echo "${1}" | rev | cut -d/ -f1 | rev)
    if check_directory_exists "${APP}"; then
        # options: PATH LABEL POSITION
        dockutil --add "${APP}" --label "${LABEL}" --position "${2}" --no-restart &> /dev/null
        echo -e "App added: ${1} (\"${APP}\")"
    else
        error "App not exists: ${1} (\"${APP}\")"
    fi
}

# Setup all dock apps and folders icons
function dockutil_setup_all_apps(){
    local A=1 # apps position counter
    local F=1 # folders position counter

    # start removing all icons from dock
    dockutil_remove_all

    # start adding all apps
    for i in "${APPS[@]}"; do
        dockutil_add_app "${i}" "$((A++))"
    done

    # start adding all folders
    for i in "${FOLDERS[@]}"; do
      local folder
      eval folder="${i[*]}"
      # options: PATH NAME POSITION VIEW
      dockutil_add_folder "${folder[0]}" "${folder[1]}" "$((F++))" "${folder[2]}"
    done

    # update docksetup
    touch "${HOME}/Library/Preferences/com.company.docksetup.plist"
    # restart dock
    killall -KILL Dock
}

# Start setup
dockutil_setup_all_apps
