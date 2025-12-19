#!/bin/zsh
# zsh-management.sh


#################
# Package Lists
#################

# Core – dotfiles depend on these, don't remove
CorePackages=(
  git                      # version control
  nvm                      # node version manager
  pyenv                    # python version manager
  zinit                    # zsh plugin manager
  fzf                      # fuzzy finder (us() pickers)
  zoxide                   # smart cd
  starship                 # prompt
  eza                      # modern ls (l, ll, la)
  trash                    # safe rm (srm)
  openssh                  # ssh tools
)

ZshPlugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Dev tools - safe to add/remove
DevTools=(
  bat                      # better cat
  bat-extras               # batgrep, batman, batdiff, prettybat
  btop                     # system monitor
  ripgrep                  # fast grep (rg)
  fd                       # fast find
  neovim                   # editor
  lazygit                  # git TUI
  tmux                     # terminal multiplexer
  yazi                     # file manager
  tldr                     # simplified man pages
  jq                       # JSON processor
  gdu                      # disk usage
  entr                     # run command when file changes
)

# Media – for audio/video work
MediaTools=(
  ffmpeg                   # video/audio processing
  yt-dlp                   # youtube downloader
)

# Network – for network tasks
NetworkTools=(
  httpie                   # http client
  wget                     # download tool
  rsync                    # file sync
  nmap                     # network scanner
)

# macOS utilities
MacosTools=(
  mas                      # mac app store CLI
)

# GUI apps (casks)
GuiApps=(
  ghostty                  # terminal
  zed                      # editor
  localsend                # file sharing
)


#################
# Shell Reload
#################

reload() {
  source "$HOME/.dotfiles/zsh/startup.sh"
}

restart() {
  clear
  exec zsh -l
}

r() { restart; }


#################
# Global Colors & Print Helper
#################

p() { builtin print -P "$@"; }

# Spacing helper - adds N blank lines for visual breathing room
# Usage: s [n]  (defaults to 1 if no arg)
s() {
  local n=${1:-1}
  for ((i=0; i<n; i++)); do
    p ""
  done
}

# Colors
NC='%f%b%k'
RED='%F{009}'
GREEN='%F{078}'
YELLOW='%F{227}'
BLUE='%F{075}'


#################
# Brew Install Helper
#################

# Formats brew install operations with spacing and visual feedback
# Has soft-fail logic built-in (doesn't call soft_fail function)
# Package name appears in green for visual hierarchy
#
# Usage: brew_install "package-name" brew install package-name
brew_install() {
  local pkg="$1"
  shift
  s 2
  p "${BLUE}installing ${GREEN}${pkg}${BLUE} via brew${NC}"
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
# Unified Installers
#################

# Install Homebrew packages (CLI tools)
installBrewPackages() {
  local category="$1"
  shift
  local packages=("$@")
  s 2
  p "${BLUE}→ ${category}${NC}"
  for pkg in "${packages[@]}"; do
    if ! brew list "$pkg" &>/dev/null 2>&1; then
      brew_install "$pkg" brew install "$pkg"
    else
      s 1
      p "${GREEN}✓${NC} $pkg ${BLUE}(already installed)${NC}"
      s 1
    fi
  done
}

# Install Homebrew casks (GUI apps)
installBrewCasks() {
  local category="$1"
  shift
  local apps=("$@")
  s 2
  p "${BLUE}→ ${category}${NC}"
  for app in "${apps[@]}"; do
    if ! brew list --cask "$app" &>/dev/null 2>&1; then
      brew_install "$app" brew install --cask "$app"
    else
      s 1
      p "${GREEN}✓${NC} $app ${BLUE}(already installed)${NC}"
      s 1
    fi
  done
}


#################
# Package Installers
#################

setupCore() {
  installBrewPackages "Core packages" "${CorePackages[@]}"
  installBrewPackages "ZSH plugins" "${ZshPlugins[@]}"
}

setupTools() { installBrewPackages "Dev tools" "${DevTools[@]}" }
setupMedia() { installBrewPackages "Media tools" "${MediaTools[@]}" }
setupNetwork() { installBrewPackages "Network tools" "${NetworkTools[@]}" }
setupMacos() { installBrewPackages "macOS utilities" "${MacosTools[@]}" }
setupApps() { installBrewCasks "GUI apps" "${GuiApps[@]}" }

setupAllPackages() {
  setupCore
  setupTools
  setupMedia
  setupNetwork
  setupMacos
  setupApps
}


#################
# Soft-fail Helper
#################

# Executes a command with soft-fail behavior
# - Preserves and restores errexit state
# - Logs success (✓) or failure (⚠) with exit code
# - Always returns 0 (never propagates failure)
#
# Used for simple operations in setupzsh() that don't need
# the fancy formatting of brew_install/npm_install
#
# Usage: soft_fail "description" command args...
soft_fail() {
  local desc="$1"
  shift
  local had_errexit=0
  [[ -o errexit ]] && had_errexit=1
  set +e
  "$@"
  local rc=$?
  (( had_errexit )) && set -e || set +e
  if (( rc == 0 )); then
    p "  ${GREEN}✓${NC} $desc"
  else
    p "  ${YELLOW}⚠${NC} $desc ${RED}(failed, continuing; rc=$rc)${NC}"
  fi
  return 0
}


#################
# Main Setup
#################

setupzsh() {
  set -e

  p '########################'
  p '#    SETTING UP ZSH    #'
  p '########################'
  s 1

  mkdir -p "$HOME/.dotfiles"
  mkdir -p "$HOME/.dotfiles/config"
  mkdir -p "$HOME/.config"


  #################
  # Xcode Command Line Tools
  #################

  if ! xcode-select -p >/dev/null 2>&1; then
    p "${BLUE}Installing Xcode Command Line Tools...${NC}"
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    CLT_PRODUCT=$(/usr/sbin/softwareupdate -l 2>/dev/null \
      | awk -F'* ' '/Command Line Tools/ {print $2}' \
      | sort -V | tail -n1)
    if [[ -n "$CLT_PRODUCT" ]]; then
      p "${BLUE}Installing:${NC} ${YELLOW}${CLT_PRODUCT}${NC}"
      if sudo /usr/sbin/softwareupdate -i "$CLT_PRODUCT" --verbose; then
        sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
        p "${GREEN}✓ Xcode Command Line Tools installed${NC}"
      else
        p "${RED}ERROR:${NC} softwareupdate failed for CLT"
        rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        set +e 2>/dev/null || true
        return 1
      fi
    else
      p "${RED}ERROR:${NC} Could not find 'Command Line Tools' in catalog"
      p "${YELLOW}Fallback:${NC} launching GUI installer..."
      xcode-select --install
      p "${YELLOW}Please complete the installation and re-run setupzsh${NC}"
      rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
      set +e 2>/dev/null || true
      return 1
    fi
    rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  else
    p "${GREEN}✓ Xcode Command Line Tools present${NC}"
  fi


  #################
  # Homebrew
  #################

  if ! command -v brew &>/dev/null; then
    p "${BLUE}Installing Homebrew...${NC}"
    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
      p "${RED}ERROR:${NC} Homebrew installation failed"
      set +e 2>/dev/null || true
      return 1
    fi
  else
    p "${GREEN}✓ Homebrew already installed${NC}"
  fi

  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  soft_fail "Updating Homebrew" brew update
  soft_fail "Running brew doctor" brew doctor


  #################
  # Package Installation
  #################

  s 4
  p "${BLUE}━━━ Package Installation ━━━${NC}"
  setupAllPackages

  if brew list --formula python &>/dev/null 2>&1; then
    soft_fail "Removing Homebrew Python (using pyenv instead)" \
      sh -c "brew uninstall --ignore-dependencies python && brew cleanup"
  fi


  #################
  # PATH Configuration
  #################

  s 4
  p "${BLUE}━━━ Environment Setup ━━━${NC}"
  s 1
  p "${BLUE}→ Setting up PATH...${NC}"
  if [[ -f "$HOME/.dotfiles/zsh/path.sh" ]]; then
    . "$HOME/.dotfiles/zsh/path.sh"
    p "${GREEN}✓ PATH configured${NC}"
  else
    p "${YELLOW}⚠ path.sh not found${NC}"
  fi


  #################
  # Config Linking
  #################

  s 2
  p "${BLUE}→ Linking configs${NC}"

  [[ -d "$HOME/.dotfiles/config/nvim" ]] && \
    ln -sf "$HOME/.dotfiles/config/nvim" "$HOME/.config/nvim" && \
    p "  ${GREEN}✓${NC} nvim"

  [[ -d "$HOME/.dotfiles/config/tmux" ]] && \
    ln -sf "$HOME/.dotfiles/config/tmux" "$HOME/.config/tmux" && \
    p "  ${GREEN}✓${NC} tmux"

  [[ -f "$HOME/.dotfiles/config/starship.toml" ]] && \
    ln -sf "$HOME/.dotfiles/config/starship.toml" "$HOME/.config/starship.toml" && \
    p "  ${GREEN}✓${NC} starship"

  [[ -d "$HOME/.dotfiles/config/zed" ]] && \
    ln -sf "$HOME/.dotfiles/config/zed" "$HOME/.config/zed" && \
    p "  ${GREEN}✓${NC} zed"

  [[ -d "$HOME/.dotfiles/config/ghostty" ]] && \
    ln -sf "$HOME/.dotfiles/config/ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty" && \
    p "  ${GREEN}✓${NC} ghostty"

  [[ -d "$HOME/.dotfiles/config/yazi" ]] && \
    ln -sf "$HOME/.dotfiles/config/yazi" "$HOME/.config/yazi" && \
    p "  ${GREEN}✓${NC} yazi"



  #################
  # Node via NVM
  #################

  s 2
  p "${BLUE}→ Setting up Node via NVM${NC}"

  export NVM_DIR="$HOME/.nvm"
  mkdir -p "$NVM_DIR"

  if [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    source "$(brew --prefix nvm)/nvm.sh"
    if [[ ! -d "$NVM_DIR/versions/node" ]]; then
      soft_fail "Installing Node (latest)" nvm install node
      soft_fail "Setting default Node" nvm alias default node
    else
      p "  ${GREEN}✓${NC} Node already installed via NVM"
    fi
  else
    p "  ${YELLOW}⚠${NC} nvm.sh not found in Homebrew"
  fi


  #################
  # Python via pyenv
  #################

  s 2
  p "${BLUE}→ Setting up Python via pyenv${NC}"

  export PYENV_ROOT="$HOME/.pyenv"
  mkdir -p "$PYENV_ROOT"

  if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    local latest_py
    latest_py=$(pyenv install --list | sed 's/^[[:space:]]*//' | grep -E '^3\.[0-9]+\.[0-9]+$' | tail -1)
    if [[ -n "$latest_py" ]]; then
      if [[ ! -d "$PYENV_ROOT/versions/$latest_py" ]]; then
        soft_fail "Installing Python $latest_py" \
          sh -c "pyenv install '$latest_py' && pyenv global '$latest_py'"
      else
        p "  ${GREEN}✓${NC} Python $latest_py already installed"
      fi
    else
      p "  ${YELLOW}⚠${NC} Could not detect latest Python 3 version"
    fi
  else
    p "  ${YELLOW}⚠${NC} pyenv not found in PATH"
  fi


  #################
  # NPM Global Packages
  #################

  if (( $+functions[npmstart] )); then
    s 2
    p "${BLUE}→ Installing npm packages${NC}"
    npmstart
  else
    p "${YELLOW}→ Skipping npm packages (npmstart not defined yet)${NC}"
  fi


  #################
  # Initialization Marker
  #################

  s 2
  p "${BLUE}→ Creating initialization marker${NC}"

  mkdir -p ~/.dotfiles

  if cat > ~/.dotfiles/.✓ << 'EOF'
# BRAVO ZSH System – Initialization Complete
#
# Usage:
#   setupzsh    # Re-run provisioning to update tools
#   wipezsh     # Erase everything and reset
#   resetzsh    # Clean slate: wipe then rebuild
#   upgradezsh  # Update to latest ZSH version
EOF
  then
    p "  ${GREEN}✓${NC} Marker file created"
  else
    p "  ${YELLOW}⚠${NC} Heredoc failed, using fallback..."
    echo "BRAVO ZSH initialized on $(date)" > ~/.dotfiles/.✓
  fi

  if [[ -f ~/.dotfiles/.✓ ]]; then
    p "  ${GREEN}✓${NC} Marker verified"
  else
    p "  ${RED}⚠${NC} Warning: Marker file not found"
    touch ~/.dotfiles/.✓ || p "  ${RED}✗${NC} Cannot create marker file"
  fi

  s 4

  p "${GREEN}✓ Setup complete!${NC}"
  p "${BLUE}→ Run 'reload' to activate your shell configuration${NC}"

  set +e 2>/dev/null || true
}


#################
# Wipe
#################

wipezsh() {
  s 2
  p "${RED}WARNING: This will completely remove your development environment.${NC}"
  read "response?Are you sure? (y/n): "
  [[ "$response" =~ '^[yY]$' ]] || { p "Cancelled."; return 1; }
  read "response2?Are you REALLY sure? (y/n): "
  [[ "$response2" =~ '^[yY]$' ]] || { p "Cancelled."; return 1; }

  if command -v brew &>/dev/null; then
    s 2
    p "${BLUE}Removing all brew packages...${NC}"
    brew uninstall --force --ignore-dependencies $(brew list) || true
    s 2
    p "${BLUE}Removing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" || true
  else
    p "${YELLOW}→ brew not found; skipping brew removal${NC}"
  fi

  p "${BLUE}Clearing system files...${NC}"
  sudo rm -rf /opt/homebrew/
  sudo rm -rf /usr/local/Homebrew/
  sudo rm -rf ~/.npm ~/.nvm ~/.pyenv
  sudo rm -f ~/.zshrc ~/.zcompdump

  s 2
  p "${GREEN}✓ Cleanup complete${NC}"
  rm -f ~/.dotfiles/.✓
  p "${YELLOW}→ Initialization marker removed${NC}"
  p "${BLUE}→ Run 'setupzsh' to rebuild${NC}"
  s 1
}


#################
# Upgrade ZSH
#################

upgradezsh() {
  if [[ ! -f ~/.dotfiles/.✓ ]]; then
    p "${RED}ERROR:${NC} setupzsh() has not run yet"
    p "${BLUE}→ Run: setupzsh${NC}"
    return 1
  fi

  if ! command -v brew &>/dev/null; then
    p "${RED}ERROR:${NC} Homebrew not found"
    return 1
  fi

  local latestZSH="$(brew --prefix)/bin/zsh"

  if [[ ! -x "$latestZSH" ]]; then
    p "${RED}ERROR:${NC} zsh not found at: $latestZSH"
    return 1
  fi

  if ! grep -q "$latestZSH" /etc/shells; then
    sudo sh -c "echo '$latestZSH' >> /etc/shells"
  fi

  s 4
  p "${BLUE}Setting default shell to Homebrew ZSH...${NC}"
  chsh -s "$latestZSH" "$USER"
  p "${GREEN}✓ Default shell updated${NC}"
  s 1
}
alias upzsh='upgradezsh'


#################
# Reset
#################

resetzsh() {
  if [[ ! -f ~/.dotfiles/.✓ ]]; then
    p "${RED}ERROR:${NC} setupzsh() has not run yet"
    p "${BLUE}→ Run: setupzsh${NC}"
    return 1
  fi
  wipezsh && setupzsh
}


#################
# System Update
#################

us() {
  set +e
  local upgrade_node=false
  local upgrade_python=false

  while (( $# )); do
    case "$1" in
      -n|--node) upgrade_node=true ;;
      -p|--python) upgrade_python=true ;;
      -np|-pn|-a|--all) upgrade_node=true; upgrade_python=true ;;
      -h|--help)
        s 1
        p "${BLUE}Usage:${NC} us [-n] [-p] [-a] [-h]"
        p "  ${GREEN}-n${NC}, ${GREEN}--node${NC}    upgrade Node version via nvm"
        p "  ${GREEN}-p${NC}, ${GREEN}--python${NC}  upgrade Python version via pyenv"
        p "  ${GREEN}-a${NC}, ${GREEN}--all${NC}     upgrade both Node and Python"
        p "  ${GREEN}-h${NC}, ${GREEN}--help${NC}    show this help"
        s 1
        return 0
        ;;
      -*)
        s 1
        p "${RED}✗ Unknown flag: $1${NC}"
        s 1
        p "${BLUE}Usage:${NC} us [-n] [-p] [-a] [-h]"
        p "  ${GREEN}-n${NC}, ${GREEN}--node${NC}    upgrade Node version via nvm"
        p "  ${GREEN}-p${NC}, ${GREEN}--python${NC}  upgrade Python version via pyenv"
        p "  ${GREEN}-a${NC}, ${GREEN}--all${NC}     upgrade both Node and Python"
        p "  ${GREEN}-h${NC}, ${GREEN}--help${NC}    show this help"
        s 1
        return 1
        ;;
    esac
    shift
  done

  s 4
  p "${BLUE}╔═══════════════════════════════════╗${NC}"
  p "${BLUE}║   Updating System & Development   ║${NC}"
  p "${BLUE}╚═══════════════════════════════════╝${NC}"
  s 1

  stty sane

  p "${BLUE}→ Updating Homebrew...${NC}"
  brew update
  brew upgrade
  p "${GREEN}✓ Homebrew updated${NC}"
  s 1

  if [[ "$upgrade_node" == true ]]; then
    if (( $+functions[nvm] )); then
      p "${BLUE}→ Updating Node...${NC}"
      local current=$(nvm current 2>/dev/null)
      local installed=$(nvm ls --no-colors | rg '^\s*v[\d.]+' -o || true)
      local selected=$(nvm ls-remote \
        | { [[ -n "$installed" ]] && rg -vFf <(echo "$installed") || cat; } \
        | fzf --ansi --tac --height=15 --prompt="Node (current: ${current:-none}) > " --reverse)
      selected=$(echo "$selected" | rg 'v[\d.]+' -o)
      if [[ -n "$selected" ]]; then
        nvm install "$selected"
        nvm alias default "$selected"
        p "${GREEN}✓ Node: ${current:-none} → ${selected}${NC}"
        s 1
      else
        p "${YELLOW}→ Skipping Node (cancelled)${NC}"
        s 1
      fi
    else
      p "${YELLOW}→ Skipping Node (nvm not loaded)${NC}"
      s 1
    fi
  fi

  if [[ "$upgrade_python" == true ]]; then
    if command -v pyenv &>/dev/null; then
      p "${BLUE}→ Updating Python...${NC}"
      local current=$(pyenv global 2>/dev/null | head -n1)
      local installed=$(pyenv versions --bare || true)
      local selected=$(pyenv install --list \
        | rg '^\s*3\.[\d.]+$' --trim \
        | { [[ -n "$installed" ]] && rg -vxFf <(echo "$installed") || cat; } \
        | fzf --tac --height=15 --prompt="Python (current: ${current:-none}) > " --reverse)
      if [[ -n "$selected" ]]; then
        pyenv install "$selected"
        pyenv global "$selected"
        p "${GREEN}✓ Python: ${current:-none} → ${selected}${NC}"
        s 1
      else
        p "${YELLOW}→ Skipping Python (cancelled)${NC}"
        s 1
      fi
    else
      p "${YELLOW}→ Skipping Python (pyenv not found)${NC}"
      s 1
    fi
  fi

  p "${BLUE}→ Updating NPM packages...${NC}"
  npm update -g
  npm upgrade -g
  p "${GREEN}✓ NPM packages updated${NC}"
  s 1

  [[ -f ~/.npmrc ]] && rm ~/.npmrc

  p "${BLUE}→ Running system maintenance...${NC}"
  if [[ -f /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister ]]; then
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
      -kill -r -domain local -domain system -domain user 2>/dev/null || true
  fi
  p "${GREEN}✓ System updated${NC}"
  s 1

  p "${GREEN}✓ All systems updated!${NC}"
  s 1
}
