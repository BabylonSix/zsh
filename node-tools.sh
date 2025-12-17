#################
# NVM — Node Version Manager
#################

# List installed versions
nvml() { nvm list; }

# Set default version: nvmu <version>
nvmu() {
  [[ -z "$1" ]] && { print "\n${RED}ERROR:${NC} nvmu <version>"; return 1; }
  nvm alias default "$1"
  nvm alias node "$1"
  nvm alias stable "$1"
  nvm use "$1"
}

# Upgrade to latest Node
nvmup() {
  # Prevent nvm prefix errors
  nvmreset() {
    npm config delete prefix
    npm config set prefix "$NVM_DIR/$(node --version)"
  }

  print ""
  nvmreset

  local myNODE=$(nvm current | grep -Eo '([0-9]+\.)+[0-9]+')
  local latestNODE=$(nvm ls-remote --lts | tail -n 1 | grep -Eo '([0-9]+\.)+[0-9]+')

  if [[ "$myNODE" == "$latestNODE" ]]; then
    print "${GREEN}v$myNODE${NC} is already the latest"
    return 0
  fi

  print "${BLUE}Upgrading Node${NC} from ${GREEN}v$myNODE${NC} to ${GREEN}v$latestNODE${NC}\n"
  nvm install node

  print "\n${BLUE}Setting default...${NC}"
  nvm alias default "$latestNODE"
  nvm alias node "$latestNODE"
  nvm use "$latestNODE"

  nvmreset

  print "\n${BLUE}Installing NPM packages...${NC}"
  npmstart

  print "\n${GREEN}✓ Node upgraded${NC}"
}


#################
# NPM — Package Management
#################

# Completions
if command -v npm >/dev/null 2>&1; then
  if whence -w bashcompinit >/dev/null 2>&1; then
    eval "$(npm completion 2>/dev/null)"
  fi
fi

# Install to dependencies
npms() { npm i -S "$@"; }

# Install to devDependencies
npmd() { npm i -D "$@"; }

# Initialize package.json
npmi() { npm init "$@"; }

# List local packages
npml() { npm ls --depth=0 "$@" 2>/dev/null; }

# List global packages
npmg() { npm ls --depth=0 -g "$@" 2>/dev/null; }
