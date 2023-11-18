#!/usr/bin/env bash

set -euo pipefail

NO_COLOR=$(tput sgr0)
RED=$(tput setaf 1)
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 11)

info() { echo -e "${CYAN}INFO: ${@}${NO_COLOR}"; }
warn() { echo -e "${YELLOW}WARN: ${@}${NO_COLOR}"; }
error() { echo -e "${RED}ERROR: ${@}${NO_COLOR}"; }

cat << EOF
___  ____ ____ ___ ____ ___ ____ ____ ___ 
|__] |  | |  |  |  [__   |  |__/ |__| |__]
|__] |__| |__|  |  ___]  |  |  \ |  | |   

EOF

# Configure passwordless sudo for the current user
info "Configure passwordless sudo for the current user..."
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${USER}
sudo chmod 0440 /etc/sudoers.d/${USER}

# Update the system and install basic packages
info "Installing required minimal APT packages..."
sudo apt update -q
sudo apt dist-upgrade -y
sudo apt install -y build-essential git sshpass curl

# Install Homebrew
info "Installing Homebrew..."
if ! command -v brew &>/dev/null; then

    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    info "Adding homebrew to $HOME/.profile (if not already there)"
    grep -q 'brew shellenv' ~/.profile || \
        (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile

    info "Loading Homebrew for the current shell..."
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Turn off analytics
    info "Turning Homebrew analytics off..."
    brew analytics off

else
  warn "You already have Homebrew installed."
  info "Checking for updates instead..."
  brew update
fi

# Install Ansible via brew
info "Brewing Ansible and friends..."
brew install ansible

# Sanity check ansible
info "Sanity check 'ansible --version'"
ansible --version

info 'Bootstrap complete! Enjoy!'
