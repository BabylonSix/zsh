# Package Managers
# BREW    -> Homebrew Software Installer
# ZINIT   -> zinit package manager
# NVM     -> Node Version Manager
# NPM     -> Node Package Manager
# PYENV   -> Python Version Manager


# Homebrew Package Manager
# If brew is not installed, run setupZSH
if [[ ! -a /opt/homebrew/bin/brew ]]; then
  setupzsh;
fi


# Node Version Manager
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
# This loads nvm bash_completion
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Python Version Manager
# To use Homebrew's directories rather than ~/.pyenv add to your profile:
export PYENV_ROOT=/opt/homebrew/var/pyenv
# To enable shims and autocompletion add to your profile:
if 
  which pyenv > /dev/null; then eval "$(pyenv init -)"; 
fi


# show version info of set languages
i() {
  echo 'Brew \t '$(brew --version)
  echo
  echo 'NVM \t v'$(nvm --version)
  echo 'NPM \t v'$(npm --version)
  echo 'Node \t '$(node --version)
  echo
  echo $(python --version)
  echo $(pyenv --version)
  echo $(pip3 --version)
  echo $(python3 --version)
}


# Zinit
. /opt/homebrew/opt/zinit/zinit.zsh
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light z-shell/F-Sy-H

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/bravo/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/bravo/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/bravo/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/bravo/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


source /Users/bravo/.docker/init-zsh.sh || true # Added by Docker Desktop