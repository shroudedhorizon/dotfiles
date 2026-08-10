# go alias path
export PATH="$PATH:$(go env GOPATH)/bin"
 
# nvm path
export NVM_DIR="$HOME/.nvm"
 
# lazy load function for NVM and related commands
_lazy_load_nvm() {
  # remove the lazy load functions to avoid constantly loading them over each other
  unset -f nvm node npm npx yarn pnpm corepack
 
  # Load the actual NVM binaries and completion scripts
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
 
  # pass the command and its arguments to the actual command
  "$@"
}
 
# lazy load nvm depending on which of these commands are run.
nvm() { _lazy_load_nvm nvm "$@"; }
node() { _lazy_load_nvm node "$@"; }
npm() { _lazy_load_nvm npm "$@"; }
npx() { _lazy_load_nvm npx "$@"; }
yarn() { _lazy_load_nvm yarn "$@"; }
pnpm() { _lazy_load_nvm pnpm "$@"; }
corepack() { _lazy_load_nvm corepack "$@"; }
 
# local bin path var
export PATH="$HOME/.local/bin:$PATH"
