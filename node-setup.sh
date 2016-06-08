# set up path to current node version
currentNode=~/.nvm/versions/node/$(node --version)


# Check if any version of Node is installed
if [[ -a $currentNode ]]; then
  'true'           # if node is installed - do nothing
else               # if node isn't found
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
  # check if package is installed
  if [[ -a $currentNode/lib/node_modules/$package ]]; then
    'true'                  # if package is installed - do nothing
  else                      # if package isn't found
    npm install -g $package # install package globally
    print '\n'              # visually separate install
  fi
done
