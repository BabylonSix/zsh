currentNode=~/.nvm/versions/node/$(node --version)

# If no version of node is installed, install node
if [[ ! -a $currentNode ]]; then
  nvm install node # install node
  print '\n\n'       # visually separate install
fi

# set up path to current node version
currentNodeBin=~/.nvm/versions/node/$(node --version)/bin

# Default NPM packages to install
npmPackages=(
  babel-cli
  babel-eslint
  babel-preset-es2015
  browser-sync
  caniuse
  cheerio
  css2stylus
  csslint
  eslint
  express
  express-generator
  graceful-fs
  gulp
  html2pug
  htmlhint
  iconv-lite
  npmvet
  pug
  pug-cli
  pug-lint
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
  vtop
  yarn
  webpack
  xmlbuilder
)

# check if packages are installed
# in current version of node, and if not, install them
installNpmPackages() {
for package in $npmPackages
do

  packageLocation=$currentNodeBin/$package
  
  # if package is not installed, install it
  if [[ ! -h $packageLocation ]]; then
    print ${RED}installing${NC} ${CYAN}$package${NC}
    npm install -g $package # install package globally
    print '\n\n\n'              # visually separate install
  fi



  # packageLocation1=$currentNodeBin/$package
  # packageLocation2=/usr/local/lib/node_modules/$package
  # packageLocation3=/usr/local/lib/node_modules/$package/bin/$package
  showLocations() {
    print ''
    print ${ORANGE}Package Name: ${NC}${CYAN}$package${NC}
    print ${ORANGE}Install Locations:${NC}
    print $packageLocation1
    print $packageLocation2
    print $packageLocation3
    print '\n\n\n'              # visually separate install     
  }


  # TEST2
  # print is ${CYAN}$package${NC} 'installed?'
  # if [[ ! -d $packageLocation2 ]]; then
  #   print ${RED}no${NC}
  #   print installing ${CYAN}$package${NC}
  #   npm install -g $package # install package globally
  #   showLocations
  # elif [[ -L $packageLocation1 && -d $packageLocation2 ]]; then
  #   print ${GREEN}yes${NC}', so we do not need to install anything'
  #   showLocations
  # fi

done
};