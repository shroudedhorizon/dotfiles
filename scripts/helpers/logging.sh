#! /bin/bash

# set up terminal colors
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    RESET='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    RESET=''
fi

####################
# output logging methods
####################
info() {
    printf '%b==>%b %s\n' "$BLUE" "$RESET" "$*"
}

success() {
    printf '%b✓%b %s\n' "$GREEN" "$RESET" "$*"
}

warning() {
    printf '%b!%b %s\n' "$YELLOW" "$RESET" "$*"
}

error() {
    printf '%b✗%b %s\n' "$RED" "$RESET" "$*" >&2
}