# Package Managers
# BREW    -> Homebrew Software Installer
# ZINIT   -> zinit package manager
# NVM     -> Node Version Manager
# NPM     -> Node Package Manager
# PYENV   -> Python Version Manager

########################################
# Homebrew
########################################

# If brew is not installed, run setupzsh (provisioning)
if ! command -v brew >/dev/null 2>&1; then
  # assumes setupzsh is defined in setup.sh, sourced before this file
  if [[ "$(type -t setupzsh)" == "function" ]]; then
    setupzsh
  fi
fi

########################################
# NVM — Node Version Manager
########################################

export NVM_DIR="$HOME/.nvm"

if command -v brew >/dev/null 2>&1; then
  _nvm_prefix="$(brew --prefix nvm 2>/dev/null)"

  # This loads nvm
  if [[ -s "${_nvm_prefix}/nvm.sh" ]]; then
    . "${_nvm_prefix}/nvm.sh"
  fi

  # This loads nvm bash_completion (fine in zsh too)
  if [[ -s "${_nvm_prefix}/etc/bash_completion.d/nvm" ]]; then
    . "${_nvm_prefix}/etc/bash_completion.d/nvm"
  fi
fi

unset _nvm_prefix

########################################
# PYENV — Python Version Manager
########################################

# Keep this consistent with setupzsh()
export PYENV_ROOT="$HOME/.pyenv"

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

########################################
# Version Summary — i()
########################################

i() {
  # Homebrew
  if command -v brew >/dev/null 2>&1; then
    print "Brew   : $(brew --version | head -n 1)"
  else
    print "Brew   : (not installed)"
  fi

  # NVM / Node / NPM
  if command -v nvm >/dev/null 2>&1; then
    print "NVM    : v$(nvm --version)"
  else
    print "NVM    : (not installed)"
  fi

  if command -v node >/dev/null 2>&1; then
    print "Node   : $(node --version)"
  else
    print "Node   : (not installed)"
  fi

  if command -v npm >/dev/null 2>&1; then
    print "NPM    : v$(npm --version)"
  else
    print "NPM    : (not installed)"
  fi

  # Python / pyenv / pip3
  if command -v python >/dev/null 2>&1; then
    print "Python : $(python --version 2>/dev/null)"
  else
    print "Python : (not installed)"
  fi

  if command -v python3 >/dev/null 2>&1; then
    print "Python3: $(python3 --version 2>/dev/null)"
  else
    print "Python3: (not installed)"
  fi

  if command -v pyenv >/dev/null 2>&1; then
    print "pyenv  : $(pyenv --version 2>/dev/null)"
  else
    print "pyenv  : (not installed)"
  fi

  if command -v pip3 >/dev/null 2>&1; then
    print "pip3   : $(pip3 --version 2>/dev/null)"
  else
    print "pip3   : (not installed)"
  fi
}

########################################
# Zinit — ZSH Plugin Manager
########################################

# Brew-installed zinit
if command -v brew >/dev/null 2>&1; then
  _zinit_prefix="$(brew --prefix zinit 2>/dev/null)"

  if [[ -f "${_zinit_prefix}/zinit.zsh" ]]; then
    . "${_zinit_prefix}/zinit.zsh"

    # Core plugins (matching setupzsh-installed formulae)
    zinit light zsh-users/zsh-syntax-highlighting
    zinit light zsh-users/zsh-autosuggestions
    zinit light z-shell/F-Sy-H
  fi
fi

unset _zinit_prefix

########################################
# Docker Desktop (optional)
########################################

# Added by Docker Desktop (made portable)
if [[ -f "$HOME/.docker/init-zsh.sh" ]]; then
  source "$HOME/.docker/init-zsh.sh"
fi