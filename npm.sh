# node version list
nvml() { nvm list; }

# use node version
nvmu() { nvm use $1; }

# npm completions
eval "$(npm completion 2>/dev/null)"

# Install and save to dependencies in your package.json
# npms is used by https://www.npmjs.com/package/npms
alias npms="npm i -S "

# Install and save to dev-dependencies in your package.json
# npmd is used by https://github.com/dominictarr/npmd
alias npmd="npm i -D "


# Initialize NPM
alias npmi='npm init '


# Lists Local NPM Packages
npml() { npm ls --depth=0 "$@" 2>/dev/null; }

# Lists Global NPM Packages
npmg() { npm ls --depth=0 -g 2>/dev/null; }



# Default NPM Libraries
npmPackages=(
  babel-cli
  babel-eslint
  babel-preset-es2015
  browser-sync
  browserify
  cheerio
  css2stylus
  csslint
  eslint
  express
  express-generator
  graceful-fs
  gulp
  html2jade
  htmlhint
  iconv-lite
  jade
  jade-lint
  jstransformer
  jstransformer-babel
  jstransformer-coffee-script
  jstransformer-marked
  jstransformer-stylus
  osascript
  postcss
  postcss-cli
  sass-lint
  simplecrawler
  standard
  standard-format
  stylint
  stylus
  trash
  vtop
  webpack
  xmlbuilder
)

for package in $npmPackages
do
  # Enter the full node version number on `nvm alias default` for command tool to work properly
  currentNode=~/.nvm/versions/node/$(cat ~/.nvm/alias/default)/lib/node_modules
  # check if package is installed
  if [[ -a $currentNode/$package ]]; then
  # if program is installed - do nothing
    'true'
  else
    # install package globally
    npm install -g $package
    # divide the installs visually with 2 newlines
    print '\n'
  fi
done
