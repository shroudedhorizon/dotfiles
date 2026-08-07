###### motd #####
#
#
current_host=$(hostname -s)
figlet -f $HOME/rectangles.flf $current_host
fortune

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Not needed, currently overridden by Starship
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
# For docker and k8s aliases, use the docker and kubectl plugins.
plugins=(git history)

source $ZSH/oh-my-zsh.sh

# To add more aliases without editing this main file, add them in ~/.zshrc.additions.
EXTRA_ALIASES=~/.zshrc.additions && test -f $EXTRA_ALIASES && source $EXTRA_ALIASES

# aliases
alias dev='cd ~/projects'
alias dots='cd ~/dotfiles'
alias gclean='git reset --hard && git clean -fd'

# go alias
export PATH="$PATH:$(go env GOPATH)/bin"

# Lazy load nvm as I hardly ever use it.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@"

eval "$(starship init zsh)"
