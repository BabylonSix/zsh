#!/bin/zsh

#################
# Package Lists
#################

# Core — dotfiles depend on these, don't remove
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

# Dev tools - not system critical but useful
DevTools=(
  bat                      # better cat
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
)

# Media — for audio/video work
MediaTools=(
  ffmpeg                   # video/audio processing
  yt-dlp                   # youtube downloader
)

# Network — for network tasks
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

# GUI apps (casks) - safe to add/remove
GuiApps=(
  ghostty                  # terminal
  zed                      # editor
  localsend                # file sharing
)


#################
# Unified Installers
#################

installBrewPackages() {
  local category="$1"
  shift
  local packages=("$@")

  print "${BLUE}→ ${category}${NC}"
  for pkg in "${packages[@]}"; do
    if ! brew list "$pkg" &>/dev/null 2>&1; then
      print "  ${YELLOW}→${NC} $pkg"
      brew install "$pkg" || print "  ${RED}⚠${NC} Failed: $pkg"
    else
      print "  ${GREEN}✓${NC} $pkg"
    fi
  done
  print ""
}

installBrewCasks() {
  local category="$1"
  shift
  local apps=("$@")

  print "${BLUE}→ ${category}${NC}"
  for app in "${apps[@]}"; do
    if ! brew list --cask "$app" &>/dev/null 2>&1; then
      print "  ${YELLOW}→${NC} $app"
      brew install --cask "$app" || print "  ${RED}⚠${NC} Failed: $app"
    else
      print "  ${GREEN}✓${NC} $app"
    fi
  done
  print ""
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
# Main Setup
#################

setupzsh() {
  # Print wrapper for color codes (matches alias in colors.sh)
  print() { builtin print -P "$@" }

  # Colors (for fresh machines before colors.sh loads)
  local NC='%f%b%k'
  local RED='%F{009}'
  local GREEN='%F{078}'
  local YELLOW='%F{227}'
  local BLUE='%F{075}'

  set -e  # Exit immediately if any command fails


  print '########################'
  print '#    SETTING UP ZSH    #'
  print '########################'
  print '\n'

  # Ensure base directories exist
  mkdir -p "$HOME/.dotfiles"
  mkdir -p "$HOME/.dotfiles/config"
  mkdir -p "$HOME/.config"


  # Xcode Command Line Tools
  if ! xcode-select -p >/dev/null 2>&1; then
    print "${BLUE}Installing Xcode Command Line Tools...${NC}"

    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

    CLT_PRODUCT=$(/usr/sbin/softwareupdate -l 2>/dev/null \
      | awk -F'* ' '/Command Line Tools/ {print $2}' \
      | sort -V | tail -n1)

    if [[ -n "$CLT_PRODUCT" ]]; then
      print "${BLUE}Installing:${NC} ${YELLOW}${CLT_PRODUCT}${NC}"
      if sudo /usr/sbin/softwareupdate -i "$CLT_PRODUCT" --verbose; then
        sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
        print "${GREEN}✓ Xcode Command Line Tools installed${NC}"
      else
        print "${RED}ERROR:${NC} softwareupdate failed for CLT"
        rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        set +e 2>/dev/null || true
        return 1
      fi
    else
      print "${RED}ERROR:${NC} Could not find 'Command Line Tools' in catalog"
      print "${YELLOW}Fallback:${NC} launching GUI installer..."
      xcode-select --install
      print "${YELLOW}Please complete the installation and re-run setupzsh${NC}"
      rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
      set +e 2>/dev/null || true
      return 1
    fi

    rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  else
    print "${GREEN}✓ Xcode Command Line Tools present${NC}"
  fi


  # Homebrew
  if ! command -v brew &>/dev/null; then
    print "${BLUE}Installing Homebrew...${NC}"
    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
      print "${RED}ERROR:${NC} Homebrew installation failed"
      set +e 2>/dev/null || true
      return 1
    fi
  else
    print "${GREEN}✓ Homebrew already installed${NC}"
  fi

  if [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  print "${BLUE}→ Running brew doctor...${NC}"
  brew doctor || true
  print ""


  # Install all packages
  setupAllPackages


  # Remove Homebrew Python (use pyenv instead)
  if brew list --formula python &>/dev/null 2>&1; then
    print "${BLUE}→ Removing Homebrew Python (using pyenv instead)...${NC}"
    brew uninstall --ignore-dependencies python || true
    brew cleanup
  fi


  # Source PATH
  print "${BLUE}→ Setting up PATH...${NC}"
  if [[ -f "$HOME/.dotfiles/zsh/path.sh" ]]; then
    . "$HOME/.dotfiles/zsh/path.sh"
  else
    print "${YELLOW}⚠ path.sh not found${NC}"
  fi
  print ""


  # Link configs
  print "${BLUE}→ Linking configs${NC}"

  [[ -d "$HOME/.dotfiles/config/nvim" ]] && \
    ln -sf "$HOME/.dotfiles/config/nvim" "$HOME/.config/nvim" && \
    print "  ${GREEN}✓${NC} nvim"

  [[ -d "$HOME/.dotfiles/config/tmux" ]] && \
    ln -sf "$HOME/.dotfiles/config/tmux" "$HOME/.config/tmux" && \
    print "  ${GREEN}✓${NC} tmux"

  [[ -f "$HOME/.dotfiles/config/starship.toml" ]] && \
    ln -sf "$HOME/.dotfiles/config/starship.toml" "$HOME/.config/starship.toml" && \
    print "  ${GREEN}✓${NC} starship"

  [[ -d "$HOME/.dotfiles/config/zed" ]] && \
    ln -sf "$HOME/.dotfiles/config/zed" "$HOME/.config/zed" && \
    print "  ${GREEN}✓${NC} zed"

  [[ -d "$HOME/.dotfiles/config/ghostty" ]] && \
    ln -sf "$HOME/.dotfiles/config/ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty" && \
    print "  ${GREEN}✓${NC} ghostty"

  [[ -d "$HOME/.dotfiles/config/yazi" ]] && \
    ln -sf "$HOME/.dotfiles/config/yazi" "$HOME/.config/yazi" && \
    print "  ${GREEN}✓${NC} yazi"

  print ""


  # Node via NVM
  print "${BLUE}→ Setting up Node via NVM${NC}"

  export NVM_DIR="$HOME/.nvm"
  mkdir -p "$NVM_DIR"

  if [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    source "$(brew --prefix nvm)/nvm.sh"

    if [[ ! -d "$NVM_DIR/versions/node" ]]; then
      print "  ${YELLOW}→${NC} Installing Node (latest)"
      if nvm install node; then
        nvm alias default node
        print "  ${GREEN}✓${NC} Node installed via NVM"
      else
        print "  ${RED}⚠${NC} Failed to install Node"
      fi
    else
      print "  ${GREEN}✓${NC} Node already installed via NVM"
    fi
  else
    print "  ${RED}⚠${NC} nvm.sh not found in Homebrew"
  fi

  print ""


  # Python via pyenv
  print "${BLUE}→ Setting up Python via pyenv${NC}"

  export PYENV_ROOT="$HOME/.pyenv"
  mkdir -p "$PYENV_ROOT"

  if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"

    local latest_py
    latest_py=$(pyenv install --list | sed 's/^[[:space:]]*//' | grep -E '^3\.[0-9]+\.[0-9]+$' | tail -1)

    if [[ -n "$latest_py" ]]; then
      if [[ ! -d "$PYENV_ROOT/versions/$latest_py" ]]; then
        print "  ${YELLOW}→${NC} Installing Python $latest_py"
        if pyenv install "$latest_py"; then
          pyenv global "$latest_py"
          print "  ${GREEN}✓${NC} Python $latest_py installed"
        else
          print "  ${RED}⚠${NC} Failed to install Python $latest_py"
        fi
      else
        print "  ${GREEN}✓${NC} Python $latest_py already installed"
      fi
    else
      print "  ${RED}⚠${NC} Could not detect latest Python 3 version"
    fi
  else
    print "  ${RED}⚠${NC} pyenv not found in PATH"
  fi

  print ""


  # NPM packages
  if (( $+functions[npmstart] )); then
    print "${BLUE}→ Installing npm packages${NC}"
    npmstart || print "  ${YELLOW}⚠${NC} Some npm packages failed to install"
  else
    print "${YELLOW}→ Skipping npm packages (npmstart not defined yet)${NC}"
  fi

  print ""


  # Create initialization marker
  print "${BLUE}→ Creating initialization marker${NC}"

  mkdir -p ~/.dotfiles

  if cat > ~/.dotfiles/.✓ << 'EOF'
# BRAVO ZSH System — Initialization Complete
#
# Usage:
#   setupzsh    # Re-run provisioning to update tools
#   wipezsh     # Erase everything and reset
#   resetzsh    # Clean slate: wipe then rebuild
#   upgradezsh  # Update to latest ZSH version
EOF
  then
    print "  ${GREEN}✓${NC} Marker file created"
  else
    print "  ${YELLOW}⚠${NC} Heredoc failed, using fallback..."
    echo "BRAVO ZSH initialized on $(date)" > ~/.dotfiles/.✓
  fi

  if [[ -f ~/.dotfiles/.✓ ]]; then
    print "  ${GREEN}✓${NC} Marker verified"
  else
    print "  ${RED}⚠${NC} Warning: Marker file not found"
    touch ~/.dotfiles/.✓ || print "  ${RED}✗${NC} Cannot create marker file"
  fi

  print ""


  # Done
  print "${GREEN}✓ Setup complete!${NC}"
  print "${BLUE}→ Run 'reload' to activate your shell configuration${NC}"

  set +e 2>/dev/null || true
}


#################
# Wipe
#################

wipezsh() {
  print "\n${RED}WARNING: This will completely remove your development environment.${NC}"
  read "response?Are you sure? (y/n): "

  if [[ "$response" != "y" && "$response" != "Y" ]]; then
    print "Cancelled."
    return 1
  fi

  read "response2?Are you REALLY sure? (y/n): "

  if [[ "$response2" != "y" && "$response2" != "Y" ]]; then
    print "Cancelled."
    return 1
  fi

  print "\n${BLUE}Removing all brew packages...${NC}"
  brew uninstall --force $(brew list) || true

  print "${BLUE}Removing Homebrew...${NC}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)" || true

  print "${BLUE}Clearing system files...${NC}"
  sudo rm -rf /opt/homebrew/
  sudo rm -rf ~/.npm ~/.nvm ~/.pyenv
  sudo rm -f ~/.zshrc ~/.zcompdump

  print "\n${GREEN}✓ Cleanup complete${NC}"

  rm -f ~/.dotfiles/.✓
  print "${YELLOW}→ Initialization marker removed${NC}"
  print "${BLUE}→ Run 'setupzsh' to rebuild${NC}\n"
}


#################
# Upgrade ZSH
#################

upgradezsh() {
  if [[ ! -f ~/.dotfiles/.✓ ]]; then
    print "${RED}ERROR:${NC} setupzsh() has not run yet"
    print "${BLUE}→ Run: setupzsh${NC}"
    return 1
  fi

  local latestZSH="/opt/homebrew/Cellar/zsh/$(\ls -t /opt/homebrew/Cellar/zsh/ | head -n 1)/bin/zsh"

  if ! grep -q "$latestZSH" /etc/shells; then
    sudo sh -c "echo '$latestZSH' >> /etc/shells"
  fi

  print "\n${BLUE}Setting default shell to latest ZSH...${NC}"
  chsh -s "$latestZSH" "$USER"
  print "${GREEN}✓ Default shell updated${NC}\n"
}
alias upzsh='upgradezsh'


#################
# Reset
#################

resetzsh() {
  if [[ ! -f ~/.dotfiles/.✓ ]]; then
    print "${RED}ERROR:${NC} setupzsh() has not run yet"
    print "${BLUE}→ Run: setupzsh${NC}"
    return 1
  fi

  wipezsh && setupzsh
}


#################
# System Update
#################

us() {
  local upgrade_node=false
  local upgrade_python=false

  while (( $# )); do
    case "$1" in
      -n|--node) upgrade_node=true ;;
      -p|--python) upgrade_python=true ;;
      -np|-pn|-a|--all) upgrade_node=true; upgrade_python=true ;;
      -h|--help)
        print ""
        print "${BLUE}Usage:${NC} us [-n] [-p] [-a] [-h]"
        print "  ${GREEN}-n${NC}, ${GREEN}--node${NC}    upgrade Node version via nvm"
        print "  ${GREEN}-p${NC}, ${GREEN}--python${NC}  upgrade Python version via pyenv"
        print "  ${GREEN}-a${NC}, ${GREEN}--all${NC}     upgrade both Node and Python"
        print "  ${GREEN}-h${NC}, ${GREEN}--help${NC}    show this help"
        print ""
        return 0
        ;;
      -*)
        print ""
        print "${RED}✗ Unknown flag: $1${NC}\n"
        print "${BLUE}Usage:${NC} us [-n] [-p] [-a] [-h]"
        print "  ${GREEN}-n${NC}, ${GREEN}--node${NC}    upgrade Node version via nvm"
        print "  ${GREEN}-p${NC}, ${GREEN}--python${NC}  upgrade Python version via pyenv"
        print "  ${GREEN}-a${NC}, ${GREEN}--all${NC}     upgrade both Node and Python"
        print "  ${GREEN}-h${NC}, ${GREEN}--help${NC}    show this help"
        print ""
        return 1
        ;;
    esac
    shift
  done

  print "\n${BLUE}╔═══════════════════════════════════╗${NC}"
  print "${BLUE}║   Updating System & Development   ║${NC}"
  print "${BLUE}╚═══════════════════════════════════╝${NC}\n"

  stty sane

  # Homebrew
  print "${BLUE}→ Updating Homebrew...${NC}"
  brew update
  brew upgrade
  print "${GREEN}✓ Homebrew updated${NC}\n"

  # Node (only with -n flag)
  if [[ "$upgrade_node" == true ]]; then
    if (( $+functions[nvm] )); then
      print "${BLUE}→ Updating Node...${NC}"

      local current=$(nvm current 2>/dev/null)
      local installed=$(nvm ls --no-colors | rg '^\s*v[\d.]+' -o || true)

      local selected=$(nvm ls-remote \
        | { [[ -n "$installed" ]] && rg -vFf <(echo "$installed") || cat; } \
        | fzf --ansi --tac --height=15 --prompt="Node (current: ${current:-none}) > " --reverse)

      selected=$(echo "$selected" | rg 'v[\d.]+' -o)

      if [[ -n "$selected" ]]; then
        nvm install "$selected"
        nvm alias default "$selected"
        print "${GREEN}✓ Node: ${current:-none} → ${selected}${NC}\n"
      else
        print "${YELLOW}→ Skipping Node (cancelled)${NC}\n"
      fi
    else
      print "${YELLOW}→ Skipping Node (nvm not loaded)${NC}\n"
    fi
  fi

  # Python (only with -p flag)
  if [[ "$upgrade_python" == true ]]; then
    if command -v pyenv &>/dev/null; then
      print "${BLUE}→ Updating Python...${NC}"

      local current=$(pyenv global 2>/dev/null | head -n1)
      local installed=$(pyenv versions --bare || true)

      local selected=$(pyenv install --list \
        | rg '^\s*3\.[\d.]+$' --trim \
        | { [[ -n "$installed" ]] && rg -vxFf <(echo "$installed") || cat; } \
        | fzf --tac --height=15 --prompt="Python (current: ${current:-none}) > " --reverse)

      if [[ -n "$selected" ]]; then
        pyenv install "$selected"
        pyenv global "$selected"
        print "${GREEN}✓ Python: ${current:-none} → ${selected}${NC}\n"
      else
        print "${YELLOW}→ Skipping Python (cancelled)${NC}\n"
      fi
    else
      print "${YELLOW}→ Skipping Python (pyenv not found)${NC}\n"
    fi
  fi

  # NPM
  print "${BLUE}→ Updating NPM packages...${NC}"
  npm update -g
  npm upgrade -g
  print "${GREEN}✓ NPM packages updated${NC}\n"

  [[ -f ~/.npmrc ]] && rm ~/.npmrc

  # System maintenance
  print "${BLUE}→ Running system maintenance...${NC}"
  if [[ -f /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister ]]; then
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
      -kill -r -domain local -domain system -domain user 2>/dev/null || true
  fi
  print "${GREEN}✓ System updated${NC}\n"

  print "${GREEN}✓ All systems updated!${NC}\n"
}
