# node version list
nvml() { nvm list; }

# use node version
nvmu() { nvm use $1; }

# upgrade node version
nvmup() {

  nvmreset(){
    # prevent stupid nvm errors
    npm config delete prefix
    npm config set prefix $NVM_DIR/$(node --version)
  }

  print '' #vertical spacing

  revolver --style 'pong' start 'Checking if you have the latest version of NodeJS'
  nvmreset
  myNODE=$(nvm ls | grep -Eo '\sv(\d+\.)+\d+' | tail -n 1 | tr -d '[:cntrl:]' | grep -Eo --colour=never '(\d+\.)+\d+')

  latestNODE=$(nvm ls-remote | tail -n 1 | tr -d '[:cntrl:]' | grep -Eo --colour=never '(\d+\.)+\d+')
  revolver stop
  
  if is-at-least $latestNODE $myNODE; then
    print '${GREEN}$myNODE${NC} is the latest version of node'
  else
  
    # install latest version of node
    print '${BLUE}Upgrading NodeJS${NC} from ${GREEN}v$myNODE${NC} to ${GREEN}v$latestNODE${NC} \n'
    nvm i node
    print '\n\n\n'          # divide the installs visually with 2 newlines

    # setup default node version
    print '${BLUE}Setting default node version${NC} \n'
    nvm alias default $latestNODE
    nvm alias node $latestNODE
    nvm use $latestNODE
    print '\n\n\n'          # divide the installs visually with 2 newlines
    
    nvmreset

    # install NPM packages
    print '${BLUE}Install my default NPM packages${NC} \n'
    npmstart

fi
}

# npm completions
eval "$(npm completion 2>/dev/null)"

# Install and save to dependencies in your package.json
# npms is used by https://www.npmjs.com/package/npms
alias npms="npm i -S"

# Install and save to dev-dependencies in your package.json
# npmd is used by https://github.com/dominictarr/npmd
alias npmd="npm i -D"


# Initialize NPM
alias npmi='npm init'


# Lists Local NPM Packages
npml() { npm ls --depth=0 "$@" 2>/dev/null; }

# Lists Global NPM Packages
npmg() { npm ls --depth=0 -g 2>/dev/null; }
