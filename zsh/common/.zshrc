###### motd #####
current_host=$(hostname -s)
figlet -f $HOME/rectangles.flf $current_host
fortune

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
# For docker and k8s aliases, use the docker and kubectl plugins.
plugins=(git history)

source $ZSH/oh-my-zsh.sh

# Load additional zsh configurations, located in .zshrc.d/
if [[ -d ~/.zshrc.d ]]; then
    for config in ~/.zshrc.d/*.zsh(N); do
        [[ -r "$config" ]] && source "$config"
    done
fi

# aliases
alias dev='cd ~/projects'
alias dots='cd ~/dotfiles'
alias gclean='git reset --hard && git clean -fd'

# run starship. make sure this line is always last.
eval "$(starship init zsh)"
