# node version list
nvml() { nvm list; }

# use node version
nvmu() { nvm use $1; }

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