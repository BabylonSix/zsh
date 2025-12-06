#!/bin/zsh

setupzsh() {
  ############# setup function environment #####################
  # Print wrapper for color codes (matches alias in colors.sh)
  print() { builtin print -P "$@" }

  # Colors (for fresh machines before colors.sh loads)
  local NC='%f%b%k'
  local RED='%F{009}'
  local GREEN='%F{078}'
  local YELLOW='%F{227}'
  local BLUE='%F{075}'

  set -e  # Exit immediately if any command fails
  #############################################################


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
        print "${GREEN}✔ Xcode Command Line Tools installed${NC}"
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
    print "${GREEN}✔ Xcode Command Line Tools present${NC}"
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
    print "${GREEN}✔ Homebrew already installed${NC}"
  fi

  if [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  print "${BLUE}→ Running brew doctor...${NC}"
  brew doctor || true


  # CLI tools
  print "${BLUE}→ Installing CLI tools...${NC}"

  local Programs=(
    bat                      # cat with syntax highlighting
    btop                     # modern system monitor
    eza                      # modern ls
    fd                       # find alternative
    ffmpeg                   # video/audio processing
    fzf                      # fuzzy finder
    git                      # version control
    lazygit                  # git TUI
    httpie                   # http client
    nmap                     # network scanner
    neovim                   # text editor
    nvm                      # node version manager
    openssh                  # ssh tools
    pyenv                    # python version manager
    ripgrep                  # fast grep (rg)
    rsync                    # file sync
    starship                 # prompt
    tmux                     # terminal multiplexer
    trash                    # safe rm
    tree                     # directory tree
    wget                     # download tool
    yt-dlp                   # youtube downloader
    zinit                    # zsh plugin manager
    zoxide                   # smart cd
    yazi                     # terminal file manager
  )

  for program in "${Programs[@]}"; do
    if ! brew list "$program" &>/dev/null 2>&1; then
      print "  ${YELLOW}→${NC} Installing $program"
      brew install "$program" || print "  ${RED}⚠${NC} Failed to install $program"
    else
      print "  ${GREEN}✔${NC} $program already installed"
    fi
  done


  # Zsh plugins
  print "${BLUE}→ Installing zsh plugins...${NC}"

  local ZshPlugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
  )

  for plugin in "${ZshPlugins[@]}"; do
    if ! brew list "$plugin" &>/dev/null 2>&1; then
      print "  ${YELLOW}→${NC} Installing $plugin"
      brew install "$plugin" || print "  ${RED}⚠${NC} Failed to install $plugin"
    else
      print "  ${GREEN}✔${NC} $plugin already installed"
    fi
  done


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


  # GUI apps
  print "${BLUE}→ Installing GUI apps...${NC}"

  local Casks=(
    ghostty
    zed
  )

  for app in "${Casks[@]}"; do
    if ! brew list --cask "$app" &>/dev/null 2>&1; then
      print "  ${YELLOW}→${NC} Installing --cask $app"
      brew install --cask "$app" || print "  ${RED}⚠${NC} Failed to install $app"
    else
      print "  ${GREEN}✔${NC} $app already installed"
    fi
  done


  # Link configs
  print "${BLUE}→ Linking configs...${NC}"

  [[ -d "$HOME/.dotfiles/config/nvim" ]] && \
    ln -sf "$HOME/.dotfiles/config/nvim" "$HOME/.config/nvim" && \
    print "  ${GREEN}✔${NC} nvim config linked"

  [[ -d "$HOME/.dotfiles/config/tmux" ]] && \
    ln -sf "$HOME/.dotfiles/config/tmux" "$HOME/.config/tmux" && \
    print "  ${GREEN}✔${NC} tmux config linked"

  [[ -f "$HOME/.dotfiles/config/starship.toml" ]] && \
    ln -sf "$HOME/.dotfiles/config/starship.toml" "$HOME/.config/starship.toml" && \
    print "  ${GREEN}✔${NC} starship config linked"

  [[ -d "$HOME/.dotfiles/config/zed" ]] && \
    ln -sf "$HOME/.dotfiles/config/zed" "$HOME/.config/zed" && \
    print "  ${GREEN}✔${NC} zed config linked"

  [[ -d "$HOME/.dotfiles/config/ghostty" ]] && \
    ln -sf "$HOME/.dotfiles/config/ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty" && \
    print "  ${GREEN}✔${NC} ghostty config linked"

  [[ -d "$HOME/.dotfiles/config/yazi" ]] && \
    ln -sf "$HOME/.dotfiles/config/yazi" "$HOME/.config/yazi" && \
    print "  ${GREEN}✔${NC} yazi config linked"


  # Node via NVM
  print "${BLUE}→ Setting up Node via NVM...${NC}"

  export NVM_DIR="$HOME/.nvm"
  mkdir -p "$NVM_DIR"

  if [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    source "$(brew --prefix nvm)/nvm.sh"

    if [[ ! -d "$NVM_DIR/versions/node" ]]; then
      print "  ${YELLOW}→${NC} Installing Node (latest)"
      if nvm install node; then
        nvm alias default node
        print "  ${GREEN}✔${NC} Node installed via NVM"
      else
        print "  ${RED}⚠${NC} Failed to install Node"
      fi
    else
      print "  ${GREEN}✔${NC} Node already installed via NVM"
    fi
  else
    print "  ${RED}⚠${NC} nvm.sh not found in Homebrew"
  fi


  # Python via pyenv
  print "${BLUE}→ Setting up Python via pyenv...${NC}"

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
          print "  ${GREEN}✔${NC} Python $latest_py installed"
        else
          print "  ${RED}⚠${NC} Failed to install Python $latest_py"
        fi
      else
        print "  ${GREEN}✔${NC} Python $latest_py already installed"
      fi
    else
      print "  ${RED}⚠${NC} Could not detect latest Python 3 version"
    fi
  else
    print "  ${RED}⚠${NC} pyenv not found in PATH"
  fi


  # NPM packages
  if (( $+functions[npmstart] )); then
    print "${BLUE}→ Installing npm packages...${NC}"
    npmstart || print "  ${YELLOW}⚠${NC} Some npm packages failed to install"
  else
    print "${YELLOW}→ Skipping npm packages (npmstart not defined yet)${NC}"
  fi


  # Create initialization marker
  print "${BLUE}→ Creating initialization marker...${NC}"

  # Ensure directory exists
  mkdir -p ~/.dotfiles

  # Create marker with explicit error checking
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
    print "  ${GREEN}✔${NC} Marker file created"
  else
    # Fallback: use echo if heredoc fails
    print "  ${YELLOW}⚠${NC} Heredoc failed, using fallback method..."
    echo "BRAVO ZSH initialized on $(date)" > ~/.dotfiles/.✓
  fi

  # Verify it was created
  if [[ -f ~/.dotfiles/.✓ ]]; then
    print "  ${GREEN}✔${NC} Marker verified at: ~/.dotfiles/.✓"
  else
    print "  ${RED}⚠${NC} Warning: Marker file not found after creation"
    print "  ${BLUE}→${NC} Attempting manual touch..."
    touch ~/.dotfiles/.✓ || print "  ${RED}✗${NC} Cannot create marker file"
  fi


  # Done
  print ''
  print "${GREEN}✅ Setup complete!${NC}"
  print "${BLUE}→ Run 'reload' to activate your shell configuration${NC}"

  ############# cleanup function environment #####################
  set +e 2>/dev/null || true
  ################################################################
}


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

  print "\n${GREEN}✔ Cleanup complete${NC}"

  rm -f ~/.dotfiles/.✓
  print "${YELLOW}→ Initialization marker removed${NC}"
  print "${BLUE}→ Run 'setupzsh' to rebuild${NC}\n"
}


upgradezsh() {
  if [[ ! -f ~/.dotfiles/.✓ ]]; then
    print "${RED}ERROR:${NC} setupzsh() has not run yet"
    print "${BLUE}→ Run: setupzsh${NC}"
    return 1
  fi

  # capture latest version of zsh from homebrew
  local latestZSH="/opt/homebrew/Cellar/zsh/$(\ls -t /opt/homebrew/Cellar/zsh/ | head -n 1)/bin/zsh"

  # add to /etc/shells if not present
  if ! grep -q "$latestZSH" /etc/shells; then
    sudo sh -c "echo '$latestZSH' >> /etc/shells"
  fi

  # set as default shell
  print "\n${BLUE}Setting default shell to latest ZSH...${NC}"
  chsh -s "$latestZSH" "$USER"
  print "${GREEN}✔ Default shell updated${NC}\n"
}
alias upzsh='upgradezsh'


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
  # flags for optional version upgrades
  local upgrade_node=false
  local upgrade_python=false

  # parse flags: -n for node, -p for python, -np/-a for both, -h for help
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
        print ""
        return 1
        ;;
    esac
    shift
  done

  print "\n${BLUE}╔═══════════════════════════════════╗${NC}"
  print "${BLUE}║   Updating System & Development   ║${NC}"
  print "${BLUE}╚═══════════════════════════════════╝${NC}\n"

  # Reset terminal
  stty sane

  # Update Homebrew
  print "${BLUE}→ Updating Homebrew...${NC}"
  brew update
  brew upgrade
  print "${GREEN}✓ Homebrew updated${NC}\n"

  # Update Node version (only with -n flag)
  if [[ "$upgrade_node" == true ]]; then
    if (( $+functions[nvm] )); then
      print "${BLUE}→ Updating Node...${NC}"

      local current=$(nvm current 2>/dev/null)
      local installed=$(nvm ls --no-colors | rg '^\s*v[\d.]+' -o || true)

      local selected=$(nvm ls-remote \
        | { [[ -n "$installed" ]] && rg -vFf <(echo "$installed") || cat; } \
        | fzf --ansi --tac --height=15 --prompt="Node (current: ${current:-none}) > " --reverse)

      # extract just the version number
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

  # Update Python version (only with -p flag)
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

  # Update NPM packages
  print "${BLUE}→ Updating NPM packages...${NC}"
  npm update -g
  npm upgrade -g
  print "${GREEN}✓ NPM packages updated${NC}\n"

  # Clear npmrc
  [[ -f ~/.npmrc ]] && rm ~/.npmrc

  # System resets
  print "${BLUE}→ Running system maintenance...${NC}"
  if [[ -f /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister ]]; then
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
      -kill -r -domain local -domain system -domain user 2>/dev/null || true
  fi
  print "${GREEN}✓ System updated${NC}\n"

  print "${GREEN}✅ All systems updated!${NC}\n"
}
