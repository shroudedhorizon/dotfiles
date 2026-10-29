#! /bin/bash

get_os_friendly_name() {
    # get the right stow package based on the OS
    local zsh_package
    case "$OS_TYPE" in
        Darwin)
            zsh_package="mac"
            ;;
        Linux)
            zsh_package="linux"
            ;;
        *)
            error "Unsupported operating system: $OS_TYPE"
            return 1
            ;;
    esac

    echo "$zsh_package"
}