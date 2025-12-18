# node-management.sh

#################
# NPM Global Packages
#################

local npmPackages=(
  autoprefixer
  babel-cli
  babel-eslint
  babel-preset-env
  babel-preset-modern-browsers
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
  nodemon
  npmvet
  parcel-bundler
  pug
  pug-cli
  pug-lint
  jstransformer
  jstransformer-babel
  jstransformer-coffee-script
  jstransformer-marked
  jstransformer-stylus
  npx
  osascript
  postcss
  postcss-cli
  sass
  sass-lint
  simplecrawler
  standard
  standard-format
  stylint
  stylus
  svg-sprite
  vite
  vtop
  yarn
  webpack
  xmlbuilder
)


#################
# Node Version Check & Install
#################

currentNode=~/.nvm/versions/node/$(node --version)

if [[ ! -a $currentNode ]]; then
  nvm install node
  s 2
fi

currentNodeBin=~/.nvm/versions/node/$(node --version)/bin


#################
# NPM Install Helper
#################

# Formats npm install operations with spacing and visual feedback
# Has soft-fail logic built-in (doesn't call soft_fail function)
# Matches brew_install style for consistency
#
# Usage: npm_install "package-name" npm install -g package-name
npm_install() {
  local pkg="$1"
  shift
  s 2
  p "${BLUE}installing ${GREEN}${pkg}${BLUE} via npm${NC}"
  # Soft-fail logic directly here
  local had_errexit=0
  [[ -o errexit ]] && had_errexit=1
  set +e
  "$@"
  local rc=$?
  (( had_errexit )) && set -e || set +e
  if (( rc == 0 )); then
    p "${GREEN}✓ ${pkg}${NC}"
  else
    p "${YELLOW}⚠ ${GREEN}${pkg}${YELLOW} ${RED}(failed, rc=$rc)${NC}"
  fi
}


#################
# Install NPM Packages
#################

npmstart() {
  for package in $npmPackages; do
    packageLocation=$currentNodeBin/$package
    if [[ ! -h $packageLocation ]]; then
      npm_install "$package" npm install --location=global "$package"
    else
      s 1
      p "${GREEN}✓${NC} $package ${BLUE}(already installed)${NC}"
    fi
  done
}
