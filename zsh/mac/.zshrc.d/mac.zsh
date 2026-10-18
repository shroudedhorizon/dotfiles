### mac specific aliases and var exports
export HOMEBREW_NO_AUTO_UPDATE=1

alias caf="nohup caffeinate -d -i -m -s >/dev/null 2>&1 &"
alias decaf="pkill caffeinate"
alias brupdate="brew update && yes | brew upgrade && brew cleanup"
