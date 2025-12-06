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
