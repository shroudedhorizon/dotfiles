### mac specific aliases and var exports
export HOMEBREW_NO_AUTO_UPDATE=1
export SSH_AUTH_SOCK=~/.bitwarden-ssh-agent.sock

alias caf="nohup caffeinate -d -i -m -s >/dev/null 2>&1 &"
alias decaf="pkill caffeinate"