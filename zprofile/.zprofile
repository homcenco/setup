#!/bin/bash
# shellcheck disable=SC2142

#   ----------------------------------
#       GLOBAL variables
#   ----------------------------------

_ALIASES_DIR="$HOME/.config/aliases"

#   ----------------------------------
#       EXPORT & SOURCE
#   ----------------------------------

# If /usr/local/sbin directory exists - add sbin to export
[ -d "/usr/local/sbin" ] && export PATH="/usr/local/sbin:$PATH"

# If /usr/local/anaconda3/bin directory exists - add bin to export
[ -d "/usr/local/anaconda3/bin" ] && export PATH="/usr/local/anaconda3/bin:$PATH"

# If $HOME/.composer/vendor/bin directory exists - add bin to export
[ -d "$HOME/.composer/vendor/bin" ] && export PATH="$PATH:$HOME/.composer/vendor/bin"

# If $HOME/.bash_profile file exists - add it to source
[ -f "$HOME/.bash_profile" ] && source "$HOME"/.bash_profile

# If $HOME/.mempalace directory exists - add it to export
[ -d "$HOME/.mempalace" ] && export MEMPALACE_DIR="~/.mempalace/palace"

# Add NVM_DIR variable and nvm command to export
export NVM_DIR="$HOME/.nvm" && [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"

# If $HOME/.zmessages file exists - add it to source
[ -f "$HOME/.zmessages" ] && source "$HOME"/.zmessages

# If $HOME/.zfunctions file exists - add it to source
[ -f "$HOME/.zfunctions" ] && source "$HOME"/.zfunctions

# Auto suggestions
eval $(/usr/local/bin/brew shellenv)

#   ----------------------------------
#       REWRITES
#   ----------------------------------

alias ncu='ncu -x -u -i --format group $@'
alias rm='rm -i $@'
alias save='source_reload_zsh'

function zsudo() {
  # shellcheck disable=SC2068
  echo "$_ZSUDO" | sudo -S $@
}

#   ----------------------------------
#       Alias symlink configuration
#   ----------------------------------

alias a='automator_appearance'
alias as='alias_symlink $_ALIASES_DIR $1'

#   ----------------------------------
#       BREW aliases configuration
#   ----------------------------------

alias bc='brew cleanup'
alias bd='brew doctor'
alias bi='brew install $@'
alias bic='brew install --cask $@'
alias bs='brew_services_action start $@'
alias bsr='brew_services_action restart $@'
alias bss='brew_services_action stop $@'
alias bsl='brew_services_list'

#   ----------------------------------
#       FINDER aliases configuration
#   ----------------------------------

# Finder Find a File with a name
alias fff='finder_find_file_name $@'

# Finder Remove all .DS_Store starting from current directory and its subdirectories
alias frd='find . -name '.DS_Store' -type f -delete'

# Finder Show All hidden files and folders
alias fsa='finder_show_all_files true'

# Finder Hide All hidden files and folders
alias fha='finder_show_all_files false'

# Finder Spotlight Index turn on
alias fsi='sudo mdutil -i on /'

#   ----------------------------------
#       GIT aliases configuration
#   ----------------------------------

# Git Clean and reset Cpabox project
alias gcc='git clean -dfx -e ".env" -e "/.idea" -e "/app/Config/domains_settings/*" -e "/files/**" -e "/public/files/**" -e "/node_modules" && git reset --hard'

# Git Diff show all changed files staged and not staged
alias gd='git diff --name-only && git diff --name-only --staged | sort | uniq'

# Git Pull all
alias gp='git pull --all'

# Open chrome with disable-web-security
alias g='open -n -a "Google Chrome" --args --disable-extensions --user-data-dir="${HOME}/.google" --disable-web-security'

#   ----------------------------------
#       UPDATE aliases configuration
#   ----------------------------------

alias u='update_global'
alias ub='update_brew'
alias uc='update_composer'
alias un='update_npm'
alias ud='update_dock'
alias uz='update_zprofile'
alias ug='update_git'

#   ----------------------------------
#       SOURCES ENDING
#   ----------------------------------
#   Sources added in the end can access to
#   all previous (.zprofile) aliases shorts

# Source symlinks from _ALIASES_DIR
source_dir_symlinks "$_ALIASES_DIR"
