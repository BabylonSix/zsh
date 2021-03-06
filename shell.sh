##############
# SHELL SETUP
#
# Raise number of files a task can open concurrently
ulimit -S -n 10000

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# move or rename multiple files
autoload -U zmv

# load in new style completion for zsh
autoload -U compinit; compinit



upgradezsh() {
  # check if latest ZSH version is default, and if not, make it so

  # capture latest version of zsh
  # the backslash in \ls temporarily turns off color output
  # the -t flag in ls -t, orders results from newest to oldest
  # head -n 1 => grabs the first item from listed items 
	latestZSH=$(echo "/opt/homebrew/Cellar/zsh/$(\ls -t /opt/homebrew/Cellar/zsh/|head -n 1)/bin/zsh")

  # if latestZSH doest not exist in /etc/shells, then
  if ! grep -q $latestZSH /etc/shells; then
    sudo sh -c "echo '\n$latestZSH' >> /etc/shells"
  fi
  # setup latest ZSH version as login shell
  print '\nSetting default login shell to latest ZSH version\n'
  $(print 'chsh -s $(tail -n 1 /etc/shells) $USER')
}
alias upzsh='upgradezsh'



###############
# SHELL OPTIONS
#
shellOptions=(

# Changing Directories
auto_cd # Change directories without CD

# Completion

# Expansion and Globbing
extended_glob # turn on zsh extended globbing, like ** for recursive directories...

# History
append_history                    # adds history
hist_ignore_all_dups              # don't record duplicates in history
hist_reduceblanks                 # ignore empty inputs in history
inc_append_history share_history  # adds history incrementally and share it across sessions

# Prompting
prompt_subst # perform variable substitution in PROMPT, so we can load git branch/status

)

for option in $shellOptions
do
  set -o $option
done

# automatically put quotes around URLs
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic


# Supress "last login" message
if [[ ! -a ~/.hushlogin ]]; then
 touch ~/.hushlogin
fi

# Supress "last login" message in desktop
if [[ ! -a ~/Desktop/.hushlogin ]]; then
 touch ~/.hushlogin
fi



#####################
# ZSH COMMAND HISTORY
#
HISTFILE=~/.zsh_history # Store history here
HISTFILE=~/bin/dotfiles/zsh/.zsh_history # Location of the .histfile
HISTSIZE=10000 # History size in the terminal
SAVEHIST=10000 # Saved history size


####################
# KEYBOARD SHORTCUTS
#
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
