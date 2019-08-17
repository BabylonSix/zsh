# INSTALLATION
#
# Directory structure of zsh setup file should look as following
# ~/bin
# ├── web
# └── zsh
#     └── setup.sh
#
# If the directory structure looks like the above,
# Run the following command
#
# ln -sf ~/bin/zsh/setup.sh ~/.zshrc; zsh -l


setupzsh() {
print '########################'
print '#    SETTING UP ZSH    #'
print '########################'
print '\n'



# fix permissions
sudo chown $(whoami) /usr/local/etc;

# if brew is not installed, install it
if [[ ! -a /usr/local/bin/brew ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  print '\n\n'
fi

#fix homebrew permissions
sudo chown -R $(whoami) /usr/local/var/homebrew;

setupSources() {
  # extend the amount of available packages
  brew tap caskroom/cask     || exit; print '\n\n'
  # extend the amount of available packages
  brew tap neovim/neovim     || exit; print '\n\n'
}; setupSources




setupBrewPrograms() {
  # check if the following programs are installed,
  # if they are not, install them
  Programs=(
    nvm                      # node version manage
    tree                     # shows directory tree
    neovim                   # new vim text editor
    tmux                     # splits terminal windows
    vcprompt                 # lets git display prompt messages
    z                        # directory search tool
    httpie                   # http tool
    ack                      # grep for code
    trash                    # safe deletion
    rsync                    # sync files
    wget                     # network downloader
    nmap                     # port scanner
    netcat                   # network utility
    mpv                      # video player (better than mplayer)
    lynx                     # web browser
    mcrypt                   # encrypt|decrypt data files
    openssh                  # SSH connectivity tools
    gzip                     # file compression
    bzip2                    # file compression
    xz                       # file compression
    unzip                    # file compression
    postgres                 # sql database
    pgcli                    # postgres color command line interface
    git                      # git version control
    exiftool                 # read | write exif data
    imagemagick              # image manipulator
    xmlstarlet               # parse xml
    tesseract                # OCR
    gocr                     # another OCR
    shellcheck               # shell linter
    bash                     # updated bash
    youtube-dl               # youtube downloader
    ffmpeg                   # youtube-dl dependency
    libdvdcss                # remove copy protection from dvd's
    less                     # file content viewer
    nano                     # text editor
    emacs                    # text editing with super powers
    tmux                     # terminal screen management
    screen                   # terminal screen management
    watch                    # watches a program
    m4                       # macro processing language
    pyenv                    # python version manager
    wine                     # windows program runner
    zsh                      # updated zsh
    zsh-syntax-highlighting  # zsh highlighting
    zsh-autosuggestions      # zsh autosuggestions
    molovo/revolver/revolver # zsh progress spinner
    gcc                      # g++ C and C++ compiler
  )


  for program in $Programs
  do
    # if program is not installed, install it
    if [[ ! -a /usr/local/Cellar/$program ]]; then
      print installing $program
      brew install $program # install program
      print '\n\n'          # divide the installs visually with 2 newlines
    fi
  done




  upgradezsh

}; setupBrewPrograms


setupUtils() {
  # gnu utils, or just stuff with a ton of flags
  Utils=(
    coreutils
    binutils
    diffutils
    findutils  # collection of GNU find, xargs, and locate
    gnutls                          # transport layer library
    gnu-indent # C language beautifier
    gnu-tar    # file compression
    gnu-which  # program finder
    grep       # regex tool
    gawk                            # gnu awk (text processing)
    gnu-sed    # gnu stream editor
    ed         # text editor
  )


  for util in $Utils
  do
    # if program is not installed, install it
    if [[ ! -a /usr/local/Cellar/$util ]]; then
      print installing $util
      brew install $util # install program
      print '\n\n'          # divide the installs visually with 2 newlines
    fi
  done
}; setupUtils


# reload everything & clean install
brew uninstall python # uninstall python dependancy for vim (we'll use pyenv to manage python versions instead)
brew prune
. ~/bin/zsh/path.sh # load $PATH first


# If no version of node is installed, install node
if [[ ! -a ~/.nvm/versions/node/ ]]; then
  print installing Node JS
  nvm install node   # install node
  print '\n\n'       # visually separate install
fi
}



# If brew is not installed, run setupZSH
if [[ ! -a /usr/local/bin/brew ]]; then
  setupzsh
fi




# I'm using the following list of source control packages:
# NVM     -> Node Version Manager
# NPM     -> Node Package Manager
# PYENV   -> Python Version Manager
# GEM     -> Ruby Package Manager
# BREW    -> Homebrew Software Installer
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
. ~/bin/nvim/setup.sh                # neovim setup
. /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. ~/bin/zsh/test.sh                  # use for testing stuff out


# Python Version Manager
# To use Homebrew's directories rather than ~/.pyenv add to your profile:
export PYENV_ROOT=/usr/local/var/pyenv
# To enable shims and autocompletion add to your profile:
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi


# iTerm Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


resetzsh() {
  # uninstall all brew packages
  brew uninstall --force $(brew list)

  # uninstall homebrew
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

  # visually divide
  print "\n\n"

  # setupZSH again
  setupzsh
}


uninstallzsh() {
    # uninstall all brew packages
  brew uninstall --force $(brew list)

  # uninstall homebrew
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

  # visually divide
  print "\n\n"
}