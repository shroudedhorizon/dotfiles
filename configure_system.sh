#!/bin/bash

OS_TYPE=$(uname)
USERNAME=$(whoami)

set -euo pipefail

install_repo() {
    if [ -d "$HOME/dotfiles" ]; then
        echo "The dotfiles repo already exists, skipping install..."
        return 0
    fi

    curl -L https://github.com/shroudedhorizon/dotfiles/archive/refs/heads/main.zip -o /tmp/dotfiles.zip 
    unzip -q /tmp/dotfiles.zip -d . 
    mv dotfiles-main ~/dotfiles
    rm /tmp/dotfiles.zip
    cd ~/dotfiles
}

# sets the RTC time to 1 to avoid inaccurate time when dual booting
set_rtc_time() {
    if [[ "$OS_TYPE" == "Linux" ]]; then
        # Print message before running the command
        echo "Setting local RTC to 1..."

        # Run the command with sudo and store the exit code in a variable
        sudo timedatectl set-local-rtc 1
        exit_code=$?

        # Check the exit code to determine if the command ran successfully
        if [ $exit_code -eq 0 ]; then
            echo "Local RTC set to 1 successfully."
        else
            echo "Error: Failed to set local RTC to 1. Exit code: $exit_code"
        fi
    fi
}

set_up_git() {
    # Skip setup if a global Git config already exists.
    if [[ -f "$HOME/.gitconfig" ]]; then
        echo "Found existing ~/.gitconfig. Skipping Git user configuration."
        return 0
    fi

	local git_name=""
	local git_email=""

    while [[ -z "$git_name" ]]; do
        read -rp "Enter your full name: " git_name
    done

    while [[ -z "$git_email" ]]; do
        read -rp "Enter your email address: " git_email
    done

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"

    echo "Git has been configured:"
    echo "  Name : $(git config --global user.name)"
    echo "  Email: $(git config --global user.email)"
}

# install homebrew if on mac
install_homebrew() {
    # install homebrew and dependencies
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        echo "Installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USERNAME/.zprofile
        source /Users/$USERNAME/.zprofile
    fi
}

# install dependencies based on pkg manager
install_dependencies() {
    echo "Installing dependencies based on OS package manager..."
    if command -v apt >/dev/null 2>&1; then
        echo "APT detected. Installing dependencies..."
        xargs sudo apt install -y < $HOME/dotfiles/dependencies/deb.txt
    elif command -v dnf >/dev/null 2>&1; then
        echo "DNF detected. Installing dependencies..."
        xargs sudo dnf install -y < $HOME/dotfiles/dependencies/rhel.txt
    elif command -v brew >/dev/null 2>&1; then
        echo "Homebrew detected. Installing dependencies"

        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew is not installed."
            exit 1
        fi

        brew bundle --file="$HOME/dotfiles/dependencies/Brewfile"
    else
        echo "Unable to detect your package manager."
        exit 1;
    fi
}

install_zsh() {
    # run the command to install zshrc
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing oh my zsh..."
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    else
        echo "Oh my zsh is already installed. Skipping..."
    fi

    # install starship if not installed
    if command -v starship >/dev/null 2>&1; then
        echo "Starship is already installed. Skipping..."
    else
        echo "Installing Starship..."
        curl -sS https://starship.rs/install.sh | sh
    fi
}

post_install() {    
    cd $HOME/dotfiles

    stow --verbose --target="$HOME" --restow */ --adopt

	if [ "$SHELL" != "/bin/zsh" ]; then
		chsh -s /bin/zsh;
	fi

    cd && zsh
}

run_all() {
    install_repo
    set_rtc_time
    install_zsh
    install_homebrew
    install_dependencies
    set_up_git
    post_install
}

if [[ $# -eq 0 ]]; then
    run_all
else
    "$@"
fi
