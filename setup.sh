# INSTALLATION
#
# Directory structure of zsh setup file should look as following
# bin
# ├── web
# └── zsh
#     └── setup.sh
#
# If the directory structure looks like the above,
# Symlink the setup to .zshrc as shown below to begin setup
#
# ln -sf ~/bin/zsh/setup.sh ~/.zshrc; zsh -l


setupZSH() {

  # if brew is not installed, install it
  if [[ ! -a /usr/local/bin/brew ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi


# Load homebrew/dupes install directory (for rsync)
brew tap homebrew/dupes || exit


# check if the following programs are installed,
# if they are not, install them
brewPrograms=(
  tree        # shows directory tree
  tmux        # splits terminal windows
  antigen     # oh-my-zsh plugin manager
  vcprompt    # lets git display prompt messages
  z           # directory search tool
  nvm         # node version manage
  pyenv       # python version manager
  httpie      # http tool
  grep        # regex tool
  ack         # grep for code
  trash       # safe deletion
  rsync       # sync files
  wget        # network downloader
  nmap        # port scanner
  netcat      # network utility
  mplayer     # video player
  lynx        # web browser
  mcrypt      # encrypt|decrypt data files
  gzip        # file compression
  bzip2       # file compression
  xz          # file compression
  git         # git version control
  exiftool    # read | write exif data
  imagemagick # image manipulator
  xmlstarlet  # parse xml
  tesseract   # OCR
  gocr        # another OCR
  shellcheck  # shell linter
  youtube-dl  # youtube downloader
  ffmpeg      # youtube-dl dependency
  zsh-syntax-highlighting
)


for program in $brewPrograms
do
  # if program is not installed, install it
  if [[ ! -a /usr/local/Cellar/$program ]]; then
    brew install $program # install program
    print '\n\n'          # divide the installs visually with 2 newlines
  fi
done


# reload everything & clean install
brew prune
. ~/bin/zsh/path.sh # load $PATH first


# If no version of node is installed, install node
if [[ ! -a ~/.nvm/versions/node/ ]]; then
  nvm install node # install node
  print '\n'       # visually separate install
fi
}




resetZSH() {
  # uninstall all brew packages
  brew uninstall --force $(brew list)

  # uninstall homebrew
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

  # setupZSH again
  setupZSH
}




# If brew is not installed, run setupZSH
if [[ ! -a /usr/local/bin/brew ]]; then
  setupZSH
fi




# I'm using the following list of source control packages:
# ANTIGEN -> OH-MY-ZSH Version Manager
# NVM     -> Node Version Manager
# NPM     -> Node Package Manager
# PYENV   -> Python Version Manager
# GEM     -> Ruby Package Manager
# BREW    -> Homebrew Software Installer

# Swift Programming Language
export PATH=/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:"${PATH}"

# Python Version Manager
# To use Homebrew's directories rather than ~/.pyenv add to your profile:
export PYENV_ROOT=/usr/local/var/pyenv
# To enable shims and autocompletion add to your profile:
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

export NVM_DIR=~/.nvm
. `brew --prefix nvm`/nvm.sh




# Sources
. ~/bin/zsh/path.sh                  # load $PATH first
. ~/bin/zsh/colors.sh                # Set color variables
. ~/bin/zsh/shell.sh                 # Look & Feel of the shell
. ~/bin/zsh/directory.sh             # Directory creation|navigation
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
. `brew --prefix`/share/antigen.zsh  # OH-MY-ZSH Plugins
. /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



# iTerm Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
