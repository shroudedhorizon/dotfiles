#!/bin/bash

set -euo pipefail

# import our helpers
source "$HOME/dotfiles/scripts/helpers/logging.sh"
source "$HOME/dotfiles/scripts/helpers/functions.sh"

# system global vars
OS_TYPE=$(uname)
USERNAME=$(whoami)

install_dotfiles_repo() {
    if [ -d "$HOME/dotfiles" ]; then
        info "The dotfiles repo already exists, skipping install..."
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
        info "Setting local RTC to 1..."

        sudo timedatectl set-local-rtc 1
        exit_code=$?

        # Check the exit code to determine if the command ran successfully
        if [ $exit_code -eq 0 ]; then
            info "Local RTC set to 1 successfully."
        else
            error "Error: Failed to set local RTC to 1. Exit code: $exit_code"
        fi
    fi
}

set_up_git_config() {
    # Skip setup if a global Git config already exists.
    if [[ -f "$HOME/.gitconfig" ]]; then
        info "Found existing ~/.gitconfig. Skipping Git user configuration."
        return 0
    fi

    warning ".gitconfig not found. Creating a new one..."
    
    local git_name="${1:-}"
    local git_email="${2:-}"
    local public_key="${3:-}"
    local gpg_status_prompt=error

    while [[ -z "$git_name" ]]; do
        read -rp "Enter your full name: " git_name
    done

    while [[ -z "$git_email" ]]; do
        read -rp "Enter your email address: " git_email
    done

    info "Leave this field empty if you don't have a key."
    read -rp "Enter your SSH Public Key from Bitwarden: " public_key

    if [[ -z "$public_key" ]]; then
        warning "No SSH public key provided. Skipping GPG signing configuration."
    else
        gpg_status_prompt=success
        info "SSH key found, using for signing..."
        git config --global gpg.format ssh
        git config --global user.signingkey "$public_key"
        git config --global commit.gpgsign true
    fi

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global core.editor "nvim"

    local gpg_format
    local gpg_sign
    gpg_format="$(git config --global gpg.format || true)"
    gpg_sign="$(git config --global commit.gpgsign || true)"

    success "Git config has been set:"
    success "  Name : $(git config --global user.name)"
    success "  Email: $(git config --global user.email)"
    $gpg_status_prompt "  GPG Signing Key Format: ${gpg_format:-Not Configured}"
    $gpg_status_prompt "  GPG Signing Enabled: ${gpg_sign:-Not Configured}"
}

# install homebrew if on mac
install_homebrew() {
    # install homebrew and dependencies
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        if command -v brew >/dev/null 2>&1; then
            info "Homebrew is already installed. Skipping..."
            return 0
        else
            info "Installing homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USERNAME/.zprofile
            source /Users/$USERNAME/.zprofile
        fi
    fi
}

# install dependencies based on pkg manager
install_dependencies() {
    info "Installing dependencies based on OS package manager..."
    if command -v apt >/dev/null 2>&1; then
        info "APT detected. Installing dependencies..."
        xargs sudo apt install -y < $HOME/dotfiles/dependencies/deb.txt
    elif command -v dnf >/dev/null 2>&1; then
        info "DNF detected. Installing dependencies..."
        xargs sudo dnf install -y < $HOME/dotfiles/dependencies/rhel.txt
    elif command -v brew >/dev/null 2>&1; then
        info "Homebrew detected. Installing dependencies"

        if ! command -v brew >/dev/null 2>&1; then
            error "Homebrew is not installed."
            exit 1
        fi

        brew bundle install --file="$HOME/dotfiles/dependencies/Brewfile"
    else
        error "Unable to detect your package manager."
        exit 1;
    fi
}

# install yt-dlp, gallery-dl, and other pipx dependencies
install_pipx_dependencies() {
    packages=(
        "https://codeberg.org/mikf/gallery-dl/archive/master.tar.gz"
        "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.tar.gz"
    )

    for package in "${packages[@]}"; do
        pipx install --force "$package"
    done
    
    pipx inject --force gallery-dl yt-dlp
}

install_zsh() {
    # run the command to install zshrc
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        info "Installing oh my zsh..."
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    else
        info "Oh my zsh is already installed. Skipping..."
    fi

    # install starship if not installed
    if command -v starship >/dev/null 2>&1; then
        info "Starship is already installed. Skipping..."
    else
        info "Installing Starship..."
        curl -sS https://starship.rs/install.sh | sh
    fi
}

set_dotfile_configs() {
    cd "$HOME/dotfiles"

    # set all of the top level dotfiles first
    for package in */; do
        [[ "$package" == "zsh/" ]] && continue
        stow --verbose --target="$HOME" --restow --adopt "$package"
    done

    # get the right stow package based on the OS
    zsh_package=$(get_os_friendly_name)

    # stow the OS specific configs
    stow \
        --verbose \
        --dir="$HOME/dotfiles/zsh" \
        --target="$HOME" \
        --restow \
        --adopt \
        common "$zsh_package"

    if [[ "$SHELL" != "/bin/zsh" ]]; then
        chsh -s /bin/zsh
    fi
}

reverse_dotfile_configs() {
    cd "$HOME/dotfiles"

    # reverse stow all of the top level dotfiles
    for package in */; do
        [[ "$package" == "zsh/" ]] && continue
        stow --verbose --target="$HOME" --delete "$package"
    done

    # reverse stow the OS specific configs
    zsh_package=$(get_os_friendly_name)
    stow \
        --verbose \
        --dir="$HOME/dotfiles/zsh" \
        --target="$HOME" \
        --delete \
        common "$zsh_package"
}

post_install() {
    set_dotfile_configs

    cd
    zsh
}

run_all() {
    install_dotfiles_repo
    set_rtc_time
    install_zsh
    install_homebrew
    install_dependencies
    install_pipx_dependencies
    set_up_git_config
    post_install
}

# run all methods in this script if a param isn't passed (param being the function name)
if [[ $# -eq 0 ]]; then
    run_all
else
    "$@"
fi