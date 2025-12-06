#
# INSTALLATION
# Directory structure should look like:
# ~/.dotfiles
# ├── zsh/
# │   └── startup.sh
# ├── config/
# └── ...
#
# To install:
#   ln -sf ~/.dotfiles/zsh/startup.sh ~/.zshrc
#   zsh -l
#   setupzsh

#################
# Bootstrap Check
#################

# First-run detection: check for initialization marker
if [[ ! -f ~/.dotfiles/.✓ ]]; then
  # Print wrapper for color codes (temporary, will be redefined in colors.sh)
  print() { builtin print -P "$@" }

  # Colors for fresh shell (before colors.sh loads)
  local NC='%f%b%k'
  local RED='%F{009}'
  local GREEN='%F{078}'
  local YELLOW='%F{227}'
  local BLUE='%F{075}'

  print ""
  print "${BLUE}╔═════════════════════════════════════╗${NC}"
  print "${BLUE}║   BRAVØ ZSH — First Run Detected    ║${NC}"
  print "${BLUE}╚═════════════════════════════════════╝${NC}"
  print ""
  print "${YELLOW}This system has not been initialized yet.${NC}"
  print ""
  print "${BLUE}Initialization will:${NC}"
  print "  • Install Homebrew"
  print "  • Install development tools (Node, Python, Git, etc.)"
  print "  • Configure your shell environment"
  print "  • Takes ~30 minutes"
  print ""

  # Prompt user
  print -n "${GREEN}Run setupzsh now?${NC} (y/n): "
  read -r response

  if [[ "$response" == "y" || "$response" == "Y" ]]; then
    print ""
    print "${BLUE}→ Starting installation...${NC}"
    print ""

    # Source only what's needed for setupzsh to run
    . ~/.dotfiles/zsh/zsh-management.sh
    . ~/.dotfiles/zsh/path.sh
    . ~/.dotfiles/zsh/colors.sh

    # Run setup
    setupzsh

    print ""
    print "${GREEN}✓ Installation complete!${NC}"
    print "${BLUE}→ Restart your terminal or run: reload${NC}"
    print ""

    return 0
  else
    print ""
    print "${YELLOW}Installation skipped.${NC}"
    print ""
    print "${BLUE}To install later, run:${NC} setupzsh"
    print "${BLUE}To exit this shell:${NC} exit"
    print ""

    # Exit gracefully without loading dotfiles
    return 0
  fi

  # Cleanup: undefine temporary print function
  unfunction print 2>/dev/null || true
fi

#################
# Core ZSH
#################

. ~/.dotfiles/zsh/zsh-management.sh        # setupzsh() and related functions
. ~/.dotfiles/zsh/path.sh                  # PATH setup (zsh-first)
. ~/.dotfiles/zsh/package-managers.sh      # Homebrew/nvm/pyenv/zinit
. ~/.dotfiles/zsh/colors.sh                # Color variables

#################
# Shell UX
#################

. ~/.dotfiles/zsh/shell.sh                 # Look & feel of the shell
. ~/.dotfiles/zsh/directory-tools.sh       # Directory creation | navigation helpers
. ~/.dotfiles/zsh/directories.sh           # Predefined directory shortcuts
. ~/.dotfiles/zsh/tools.sh                 # Tools & utilitie
. ~/.dotfiles/zsh/node-setup.sh            # NVM & NPM setup + global packages
. ~/.dotfiles/zsh/node-tools.sh            # Node/NPM tools, completions, helpers
. ~/.dotfiles/zsh/completion.sh            # ZSH completions
. ~/.dotfiles/zsh/ssh.sh                   # SSH configuration
. ~/.dotfiles/zsh/git.sh                   # Git configuration
. ~/.dotfiles/zsh/alias.sh                 # Shortcut / alias commands

#################
# Optional / Project-Specific
#################

. ~/.dotfiles/web/web-path.sh 2>/dev/null || true   # Web project creation tools (optional)
. ~/.dotfiles/nvim/setup.sh 2>/dev/null || true     # Neovim setup (optional)
. ~/.dotfiles/zsh/test-tools.sh 2>/dev/null || true # Sandbox for testing new functions

# (FZF is already handled in tools.sh; no need to source ~/.fzf.zsh again here)
