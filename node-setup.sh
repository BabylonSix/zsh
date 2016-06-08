# set up path to current node version
currentNode=~/.nvm/versions/node/$(node --version)


# If no version of node is installed, install node
if [[ ! -a $currentNode ]]; then
  nvm install node # install node
  print '\n'       # visually separate install
fi



# Default NPM packages to install
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

# check if packages are installed
# in current version of node, and if not, install them
for package in $npmPackages
do
  # if package is not installed, install it
  if [[ ! -a $currentNode/lib/node_modules/$package ]]; then
    npm install -g $package # install package globally
    print '\n'              # visually separate install
  fi
done
