setupzsh() {
print '########################'
print '#    SETTING UP ZSH    #'
print '########################'
print '\n'



#-----------------------------------------------
# RESET XCODE TOOLS                            |
#-----------------------------------------------
# remove old xcode tools
sudo rm -rf /Library/Developer/CommandLineTools
# agree to xcode license
sudo xcodebuild -license
# install xcode tools
xcode-select --install
#----------------------------------------------



#-----------------------------------------------
# HOMEBREW SETUP                               |
#-----------------------------------------------
# if brew is not installed, install it
if [[ ! -a /opt/homebrew/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
  print '\n\n'
fi
#----------------------------------------------



# check for problems with brew
brew doctor

setupBrewPrograms() {
  # check if the following programs are installed,
  # if they are not, install them
  local Programs=(
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
    netcat                   # network utilitys
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
    pyenv                    # python version manager1
    zsh                      # updated zsh
    zsh-syntax-highlighting  # zsh highlighting
    zsh-autosuggestions      # zsh autosuggestions
    molovo/revolver/revolver # zsh progress spinner
    gcc                      # g++ C and C++ compiler
    cquery                   # requirement for tabnine C++ completion
    cliclick                 # tool for executing mouse/keyboard-related actions from the shell/Terminal
  )


  for program in $Programs
  do
    # if program is not installed, install it
    if [[ ! -a /opt/homebrew/Cellar/$program ]]; then
      print installing $program
      brew install $program # install program
      print '\n\n'          # divide the installs visually with 2 newlines
    fi
  done

  upgradezsh

}; setupBrewPrograms


setupUtils() {
  # gnu utils, or just stuff with a ton of flags
  local Utils=(
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
    if [[ ! -a /opt/homebrew/Cellar/$util ]]; then
      print installing $util
      brew install $util # install program
      print '\n\n'       # divide the installs visually with 2 newlines
    fi
  done
}; setupUtils


# reload everything & clean install
brew uninstall --ignore-dependencies python # uninstall python dependancy for vim (we'll use pyenv to manage python versions instead)
brew cleanup

. ~/bin/zsh/path.sh      # load $PATH first


# If no version of node is installed, install node
if [[ ! -a ~/.nvm/versions/node/ ]]; then
  print installing Node JS
  nvm install node       # install node
  print '\n\n'           # visually separate install
fi

# load npm packages listed in node-setup.sh
npmstart

} # end setupzsh





uninstallzsh() {
  # uninstall all brew packages
  brew uninstall --force $(brew list)

  # uninstall homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"

  # clear /usr/local/ of all old files to insure clean uninstall of our setup
  sudo rm -rf /usr/local/
  # clear npm & nvm packages
  sudo rm -rf ~/.npm ~/.nvm
  # clear other files installed by our dotfiles
  sudo rm ~/.babel.json ~/.z ~/.zcompdump
  # clear .zsh settings symlink
  sudo rm ~/.zshrc
  # visually divide
  print "\n\n"
}





resetzsh() {
  uninstallzsh;

  # setupZSH again
  setupzsh;
}