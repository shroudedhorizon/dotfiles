#!/bin/bash

OS_TYPE=$(uname)
USERNAME=$(whoami)
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

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

# symlink the correct dotfiles depending on the operating system we're running
set_correct_dotfiles() {
    local selected_zshrc

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        selected_zshrc="mac/.zshrc"
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        selected_zshrc="linux/.zshrc"
    else
        echo "Unsupported OS: $OS_TYPE"
        exit 1
    fi

    ln -sfn "$DOTFILES_DIR/zsh/$selected_zshrc" "$HOME/.zshrc"

    echo "Dotfiles set according to OS. $DOTFILES_DIR/zsh/$selected_zshrc -> $HOME/.zshrc"
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
        xargs sudo apt install -y < dependencies/deb.txt
    elif command -v dnf >/dev/null 2>&1; then
        echo "DNF detected. Installing dependencies..."
        xargs sudo dnf install -y < dependencies/rhel.txt
    elif command -v brew >/dev/null 2>&1; then
        echo "Homebrew detected. Installing dependencies"
        while IFS= read -r package || [ -n "$package" ]; do
            # format is cask:package
            if [[ "$package" == cask:* ]]; then
                brew install --cask "${package#cask:}"
            else
                brew install "$package"
            fi
        done < dependencies/mac.txt
    else
        echo "Unable to detect your package manager."
        exit 1;
    fi
}

#######
# function calls
#
set_rtc_time

# run the command to install zshrc
echo "Installing oh my zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

set_correct_dotfiles

install_homebrew

install_dependencies

echo "All dependencies installed! Changing shell for the final step..."