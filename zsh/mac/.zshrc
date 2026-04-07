###### motd #####
#
#
current_host=$(hostname -s)
figlet -f $HOME/smslant.flf $current_host

echo ""
fortune
echo ""

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(git history)

source $ZSH/oh-my-zsh.sh

# to add more aliases without editing this main file, add them in ~/.zshrc.additions
EXTRA_ALIASES=~/.zshrc.additions && test -f $EXTRA_ALIASES && source $EXTRA_ALIASES

# aliases
alias k="/usr/local/bin/kubectl"
alias dev='cd ~/projects'
alias dots='cd ~/dotfiles'
alias dps='docker ps'
alias gclean='git reset --hard && git clean -fd'

dgo() {
	# default entering into container with root user unless otherwise specified
	dockerUser="root"

	if [ ! -z "$2" ]
	then
		dockerUser=$2
	fi

	docker exec -it --user "$2" "$1" bash
}

kgo() {
	kubectl exec -it "$1" bash
}

# go alias
export PATH="${HOME}/.local/bin:${PATH}"
export PATH=$PATH:/usr/local/go/bin

# nvm alias
export NVM_DIR=~/.nvm
 [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
