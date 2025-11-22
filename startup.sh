# INSTALLATION
# big sur update
#
# Directory structure of zsh setup file should look as following
# ~/.dotfiles
# ├── web
# └── zsh
#     └── startup.sh
#
# If the directory structure looks like the above,
# Run the following command
#
# ln -sf ~/.dotfiles/zsh/startup.sh ~/.zshrc; zsh -l; setupzsh


# Sources
. ~/.dotfiles/zsh/setup.sh                 # setup zsh functions
. ~/.dotfiles/zsh/path.sh                  # load $PATH first
. ~/.dotfiles/zsh/package-managers.sh      # load package managers
. ~/.dotfiles/zsh/colors.sh                # Set color variables
. ~/.dotfiles/zsh/shell.sh                 # Look & Feel of the shell
. ~/.dotfiles/zsh/directory-tools.sh       # Directory creation|navigation
. ~/.dotfiles/zsh/directories.sh
. ~/.dotfiles/zsh/tools.sh                 # Tools & Utilities
. ~/.dotfiles/zsh/node-setup.sh            # NVM & NPM Setup + Packages
. ~/.dotfiles/zsh/node-tools.sh            # NPM completions, etc...
. ~/.dotfiles/zsh/completion.sh            # ZSH completions
. ~/.dotfiles/zsh/ssh.sh                   # SSH configuration
. ~/.dotfiles/zsh/git.sh                   # Git configuration
. ~/.dotfiles/zsh/extract.sh               # unzip utility
. ~/.dotfiles/zsh/alias.sh                 # Shortcut/Alias commands
. ~/.dotfiles/zsh/screen.sh                # screensize tools
. ~/.dotfiles/web/web-path.sh              # web project creation tools
. ~/.dotfiles/nvim/setup.sh                # neovim setup
. ~/.dotfiles/zsh/test-tools.sh            # use for testing stuff out

test -e /Users/bravo/.iterm2_shell_integration.zsh && source /Users/bravo/.iterm2_shell_integration.zsh || true

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/bravo/.lmstudio/bin"
