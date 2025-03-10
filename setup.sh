#!/bin/bash
set +u

# Source .zmessages
ZMESSAGES_LINK="https://raw.githubusercontent.com/homcenco/setup/main/zprofile/.zmessages"
source /dev/stdin <<< "$(curl --insecure --silent $ZMESSAGES_LINK)"
success_arrow "Loading source .zmessages"

# Setup list global variables
SETUP=(
  'setup_ssh'
  'setup_brew'
  'setup_brew_apps'
  'setup_nodejs_env'
  'setup_iterm_terminal'
  'setup_dock_apps'
  'setup_switcher'
)

# Setup ssh
# Don't forget to add it to your repositories
function setup_ssh() {
  step "Setting ssh keys!" "${1}" "${2}"
  ssh-keygen -f "${HOME}/.ssh/id_rsa" -t rsa -b 2048 -C "homcenco@gmail.com"
}

# Setup brew
function setup_brew() {
  step "Setting brew!"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew analytics off
}

# Setup brew applications
function setup_brew_apps() {
  step "Setting brew applications!" "${1}" "${2}"
  # Browser apps
  brew install --cask google-chrome yandex firefox opera surfshark
  # File apps
  brew install --cask transmit folx
  # Background apps
  brew install --cask contexts macs-fan-control rectangle-pro
  # Chatting apps
  brew install --cask telegram discord
  # Development apps
  brew install --cask webstorm pycharm visual-studio-code figma bruno termius

  # Docker
  brew install --cask docker

  # Security
  brew install --cask angry-ip-scanner
  brew install k6

  # Other
  brew install dockutil git-gui go

  # Figma disable agent
  rm -fr "${HOME}/Library/Application Support/Figma/FigmaAgent.app"
  touch "${HOME}/Library/Application Support/Figma/FigmaAgent.app"
  sudo chflags -R schg "${HOME}/Library/Application Support/Figma/FigmaAgent.app"

  # Copy my `.zprofile` config
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/setup/main/zprofile/setup.sh)"
  source "$HOME/.zprofile"
}

# Setup nodejs environment
function setup_nodejs_env() {
  step "Setting Nodejs environment!" "${1}" "${2}"
  alert "Installing nvm:"
  brew install nvm

  alert "Install node & npm 20:"
  source "$HOME/.zprofile"
  nvm install 20
  nvm alias default 20
  nvm use default

  alert "Install bun:"
  brew install oven-sh/bun/bun

  alert "Installing npm tools global packages:"
  source "$HOME/.zprofile"
  npm i -g autocannon npm-check-updates eslint yarn npm@latest

  alert "Setup commitlint for any git commit:"
  npm i -g @commitlint/{cli,config-conventional}
  echo "module.exports = { extends: ['@commitlint/config-conventional'] };" > "${HOME}/.commitlintrc.js"
  [ ! -d "${HOME}/.git/hooks" ] && mkdir -pv "${HOME}/.git/hooks"
  echo '#!/usr/bin/env sh' > "${HOME}/.git/hooks/commit-msg"
  echo "npx --no-install commitlint --edit" >> "${HOME}/.git/hooks/commit-msg"
  chmod a+x "${HOME}/.git/hooks/commit-msg"
  git config --global core.hooksPath "${HOME}/.git/hooks"
}

# Setup php environment
function setup_php_env() {
  step "Setting php environment!" "${1}" "${2}"
  alert "Installing php and apps:"
  brew install php wrk mailhog phpmyadmin
  alert "Installing php services:"
  brew install composer dnsmasq nginx mysql wget
  alert "Installing ngrok tunnel:"
  brew install ngrok/ngrok/ngrok
  alert "Rebuild composer non-political:"
  local COMPOSER_TEMP="${HOME}/composer-build"
  [ -d "${COMPOSER_TEMP}" ] && rm -rf "${COMPOSER_TEMP}"
  git clone https://github.com/composer/composer.git --branch 2.8.6  "${COMPOSER_TEMP}" && \
      composer install -o -d "${COMPOSER_TEMP}" && \
      wget https://raw.githubusercontent.com/politsin/snipets/master/patch/composer.patch -q -O "${COMPOSER_TEMP}/composer.patch"  && \
      cd "${COMPOSER_TEMP}" && patch -p1 < composer.patch && \
      php -d phar.readonly=0 bin/compile && \
      rm /usr/local/bin/composer && \
      php composer.phar install && \
      php composer.phar update && \
      mv "${COMPOSER_TEMP}/composer.phar" /usr/local/bin/composer && \
      rm -rf "${COMPOSER_TEMP}"  && \
      chmod +x /usr/local/bin/composer && \
      cd "${HOME}" || exit
}

# Setup dock applications
function setup_dock_apps() {
  step "Setting dock applications!" "${1}" "${2}"
  alert "Create folders if not exist:"
  [ ! -d "$HOME/Web" ] && mkdir "$HOME/Web"
  [ ! -d "$HOME/Work" ] && mkdir "$HOME/Work"
  alert "Reinstall all dock app and folders icons:"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/setup/main/dock/setup.sh)"
}

# Setup iterm terminal
function setup_iterm_terminal() {
  step "Setting iterm terminal!" "${1}" "${2}"
  brew install iterm2 zsh
  brew install zsh-completions zsh-autosuggestions powerlevel10k
  brew install romkatv/gitstatus/gitstatus
  chmod go-w '/usr/local/share'
  chmod -R go-w '/usr/local/share/zsh'
  # shellcheck disable=SC2129
  echo "if type brew &>/dev/null; then
            FPATH=\$(brew --prefix)/share/zsh-completions:\$FPATH

            autoload -Uz compinit
            compinit
        fi" >>~/.zshrc
  echo "source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc
  echo "source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
  # Disable .zsh_history by setting its symlink to null
  [ -f "$HOME/.zsh_history" ] && rm -f "$HOME/.zsh_history"
  ln -s "/dev/null" "$HOME/.zsh_history"
  source "$HOME/.zprofile"
}

# Setup all switcher
function setup_switcher() {
  step "Setting all configs!" "${1}" "${2}"
  local FLOW_DIR="$HOME/Library/Services"
  local FLOW_SWITCHER_FILE="Appearance_Switcher.workflow"
  local FLOW_LINK_DIR="https://raw.githubusercontent.com/homcenco/setup/main/flows"
  local FLOW_SWITCHER_LINK="$FLOW_LINK_DIR/Appearance_Switcher.workflow.zip"
  [ ! -d "${FLOW_DIR}" ] && mkdir -p "${FLOW_DIR}"
  [ ! -d "${FLOW_DIR}/${FLOW_SWITCHER_FILE}" ] && curl -o "${FLOW_DIR}/${FLOW_SWITCHER_FILE}.zip" "${FLOW_SWITCHER_LINK}"
  [ -f "${FLOW_DIR}/${FLOW_SWITCHER_FILE}.zip" ] && unzip "${FLOW_DIR}/${FLOW_SWITCHER_FILE}.zip" -d "${FLOW_DIR}" && rm -f "${FLOW_DIR}/${FLOW_SWITCHER_FILE}.zip" && rm -fr "${FLOW_DIR}__MACOSX"
}

# Setup list all
function setup_list() {
  success "Available setup step names:"
  for value in "${SETUP[@]}"; do
    echo "    $value"
  done
}

# Start step setup from SETUP list
function setup_step() {
  if [[ " ${SETUP[*]} " =~ ${1} ]];
   then eval "$1 1 1"
   else error "Error: step '$1' not found!"
   fi;
}

# Start setup all
function setup_all() {
  local c="1"
  for value in "${SETUP[@]}"; do
    eval "$value $((c++)) ${#SETUP[@]}"
  done
  open -a "iTerm"
}

# Setup help
setup_help() {
  echo "Example usage:"
  echo "/bin/bash setup.sh -s setup_ssh"
  echo "Options:"
  echo "-h     Help info"
  echo "-s     Step NAME setup from list"
  echo "-l     List all setup steps"
  echo
}

#########
# SETUP #
#########

# Check if bash is available
if [ -z "${BASH_VERSION:-}" ]; then
  error "Bash is required to interpret this script."
fi

# If option is set run commands
while getopts "hs:l" option; do
  case $option in
  h) # Setup help
    setup_help
    exit
    ;;
  s) # Setup step only
    STEP1="$OPTARG"
    setup_step "$STEP1"
    exit
    ;;
  l) # List all setup functions
    setup_list
    exit
    ;;
  \?) # Invalid option
    error "Error: Invalid option"
    setup_help
    exit
    ;;
  esac
done

# If no options set run setup_all
[ $OPTIND -eq 1 ] && setup_all
