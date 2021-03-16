# INSTALLATION
# big sur update
#
# Directory structure of zsh setup file should look as following
# ~/bin
# ├── web
# └── zsh
#     └── startup.sh
#
# If the directory structure looks like the above,
# Run the following command
#
# ln -sf ~/bin/zsh/startup.sh ~/.zshrc; zsh -l; setupzsh


# Sources
. ~/bin/zsh/setup.sh                 # setup zsh functions
. ~/bin/zsh/path.sh                  # load $PATH first
. ~/bin/zsh/package-managers.sh      # load package managers
. ~/bin/zsh/colors.sh                # Set color variables
. ~/bin/zsh/shell.sh                 # Look & Feel of the shell
. ~/bin/zsh/directory-tools.sh       # Directory creation|navigation
. ~/bin/zsh/directories.sh
. ~/bin/zsh/tools.sh                 # Tools & Utilities
. ~/bin/zsh/node-setup.sh            # NVM & NPM Setup + Packages
. ~/bin/zsh/node-tools.sh            # NPM completions, etc...
. ~/bin/zsh/completion.sh            # ZSH completions
. ~/bin/zsh/ssh.sh                   # SSH configuration
. ~/bin/zsh/git.sh                   # Git configuration
. ~/bin/zsh/extract.sh               # unzip utility
. ~/bin/zsh/alias.sh                 # Shortcut/Alias commands
. ~/bin/zsh/screen.sh                # screensize tools
. ~/bin/web/web-path.sh              # web project creation tools
. `brew --prefix`/etc/profile.d/z.sh # Lets Z work
. ~/bin/nvim/setup.sh                # neovim setup
. /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. ~/bin/zsh/test.sh                  # use for testing stuff out