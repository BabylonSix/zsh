
# Raise number of files a task can open concurrently
ulimit -S -n 4096

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# load in new style completion for zsh
autoload -U compinit
compinit

# turn on zsh extended globbing, like ** for recursive directories...
setopt extended_glob

# perform variable substitution in PROMPT, so we can load git branch/status
setopt prompt_subst

# ZSH command history
HISTFILE=~/.zsh_history # Store history here
HISTFILE=~/bin/dotfiles/zsh/.zsh_history # Location of the .histfile
HISTSIZE=10000 # History size in the terminal
SAVEHIST=10000 # Saved history size

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record duplicates in history
setopt HIST_REDUCE_BLANKS

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line

setopt AUTO_CD # Change directories without CD
