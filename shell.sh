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

# Allow bash completion scripts (like nvm/npm) to work inside zsh
autoload -U +X bashcompinit && bashcompinit



#################
# SHELL INTEGRATIONS
#################

# Starship Prompt system
[[ -x $(command -v starship) ]] && eval "$(starship init zsh)"

# Zoxide Smart directory navigation
[[ -x $(command -v zoxide) ]] && eval "$(zoxide init zsh)"

# Fuzzy finder
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh



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
HISTFILE=~/.dotfiles/zsh/.zsh_history # Location of the .histfile
HISTSIZE=10000 # History size in the terminal
SAVEHIST=10000 # Saved history size



####################
# KEYBOARD SHORTCUTS
#
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
