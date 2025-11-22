# Enable menu completion and disable automatic selection of the first entry
zstyle ':completion:*:*:*:*:*' menu select
unsetopt menu_complete

# Show completion menu on successive tab press
setopt auto_menu

# Enable command line completion even when cursor is not at the end of the word
setopt complete_in_word

# Move cursor to end of line after completion
setopt always_to_end

# Enable extended globbing patterns for file name expansion
setopt extendedglob

# Set Wordchars to empty string
WORDCHARS=''

# Load the complist module
zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
# Set case-insensitive, partial-word, and substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

# Set list colors to empty string
zstyle ':completion:*' list-colors ''

# Bind Ctrl+o to accept-and-infer-next-history action when a completion menu is displayed
bindkey -M menuselect '^o' accept-and-infer-next-history

# Set list colors for process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Set command for process completion
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# Modify cd command tab completion to prioritize local directories and only show directories in current directory
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# use /etc/hosts and known_hosts for hostname completion
[ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_global_ssh_hosts[@]"
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  "$HOST"
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts
# Enable command line completion caching and set cache directory
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH/cache/

# Ignore certain user names when performing command line completion for user names
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# Show ignored completions when only a single completion is available
zstyle '*' single-ignored show

# Set completion styles for various contexts
zstyle ':completion:*:*:*:*:*' completer _expand _complete _ignored
zstyle ':completion:*:*:cd:*' completer _cd
zstyle ':completion:*:*:pwd:*' completer _pwd
zstyle ':completion:*:*:history-words:*' completer _history
zstyle ':completion:*:*:history-words:*' stop-on-existing yes
zstyle ':completion:*:*:history-words:*' remove-all-dups yes
zstyle ':completion:*:*:history-words:*' add-space yes
zstyle ':completion:*:*:history-words:*' preserve-prefix on
zstyle ':completion:*:*:history-words:*' no-sort true
zstyle ':completion:*:*:history-words:*' group-name ''
zstyle ':completion:*:*:history-words:*' group-order versions
zstyle ':completion:*:*:history-lines:*' completer _history
zstyle ':completion:*:*:history-lines:*' stop-on-existing yes
zstyle ':completion:*:*:history-lines:*' remove-all-dups yes
zstyle ':completion:*:*:history-lines:*' add-space yes
zstyle ':completion:*:*:history-lines:*' preserve-prefix on
zstyle ':completion:*:*:history-lines:*' no-sort true
zstyle ':completion:*:*:history-lines:*' group-name ''
zstyle ':completion:*:*:history-lines:*' group-order versions
zstyle ':completion:*:*:history-lines:*' list-separator ' '

# Set default completion style
zstyle ':completion:*' completer _expand _complete _ignored

# Set keybindings for command line completion
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 2
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-prompt '%S%M matches%s'

# Set options for history completion
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' add-space yes
zstyle ':completion:*:history-words' preserve-prefix on
zstyle ':completion:*:history-words' no-sort true
zstyle ':completion:*:history-words' group-name ''
zstyle ':completion:*:history-words' group-order versions
zstyle ':completion:*:history-lines' stop yes
zstyle ':completion:*:history-lines' remove-all-dups yes
zstyle ':completion:*:history-lines' add-space yes
zstyle ':completion:*:history-lines' preserve-prefix on
zstyle ':completion:*:history-lines' no-sort true
zstyle ':completion:*:history-lines' group-name ''
zstyle ':completion:*:history-lines' group-order versions
zstyle ':completion:*:history-lines' list-separator ' '

# Set options for history expansion
zstyle ':completion:*:history-expand:*' word true
zstyle ':completion:*:history-expand:*' group-name ''
zstyle ':completion:*:history-expand:*' group-order versions
zstyle ':completion:*:history-expand:*' list-separator ' '

# Set options for file completion
zstyle ':completion:*:files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro'
zstyle ':completion:*:files' max-errors 1
zstyle ':completion:*:files' file-sort name
zstyle ':completion:*:files' group-name ''
zstyle ':completion:*:files' group-order versions
zstyle ':completion:*:files' list-separator ' '
zstyle ':completion:*:files' menu yes
zstyle ':completion:*:files' select yes
zstyle ':completion:*:files' ignore-parents parent pwd
zstyle ':completion:*:files' auto-description '%d'
zstyle ':completion:*:files' prompt '%M%B%F{red}%/%f%b%m%B%F{yellow}%[%d/%m]%f%b%m%B%F{green}%[%~]%f%b%m%B%F{blue}%[%/]%f%b%m%B%F{cyan}%[%p]%f%b%m%B%F{magenta}%[%l]%f%b%m%B%F{green}%[%?=%R]%f%b%m%B%F{yellow}%[%#=%! %B]%f%b%m'
zstyle ':completion:*:complete:-command-:*' tag-order commands functions
zstyle ':completion:*:describe:-command-:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*:commands' run-help true
zstyle ':completion:*:commands' command-path /sbin /usr/sbin /usr/local/sbin /usr/local/mysql/bin /usr/X11R6/bin
zstyle ':completion:*:functions' group-name ''
zstyle ':completion:*:functions' group-order versions
zstyle ':completion:*:functions' list-separator ' '
zstyle ':completion:*:functions' run-help true
zstyle ':completion:*:functions' tag-order functions commands
zstyle ':completion:*:functions' format '%B%F{green}%d%f%b'
zstyle ':completion:*:scalars' group-name ''
zstyle ':completion:*:scalars' group-order versions
zstyle ':completion:*:scalars' list-separator ' '
zstyle ':completion:*:arrays' group-name ''
zstyle ':completion:*:arrays' group-order versions
zstyle ':completion:*:arrays' list-separator ' '
zstyle ':completion:*:associatives' group-name ''
zstyle ':completion:*:associatives' group-order versions
zstyle ':completion:*:associatives' list-separator ' '
zstyle ':completion:*:parameters' group-name ''
zstyle ':completion:*:parameters' group-order versions
zstyle ':completion:*:parameters' list-separator ' '
zstyle ':completion:*:parameters' format '%B%F{yellow}%d%f%b'
zstyle ':completion:*:variables' group-name ''
zstyle ':completion:*:variables' group-order versions
zstyle ':completion:*:variables' list-separator ' '
zstyle ':completion:*:variables' format '%B%F{red}%d%f%b'
zstyle ':completion:*:expanders' group-name ''
zstyle ':completion:*:expanders' group-order versions
zstyle ':completion:*:expanders' list-separator ' '
zstyle ':completion:*:expanders' format '%B%F{cyan}%d%f%b'
zstyle ':completion:*:.*' group-name ''
zstyle ':completion:*:.*' group-order versions
zstyle ':completion:*:.*' list-separator ' '
zstyle ':completion:*' verbose true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

if [[ -r /etc/hosts ]]; then
  # Use /etc/hosts and known_hosts for hostname completion
  if [[ -r /etc/ssh/ssh_known_hosts ]]; then
    _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
  fi
  if [[ -r ~/.ssh/known_hosts ]]; then
    _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
  fi
  _etc_hosts=(${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}) || _etc_hosts=()
  hosts=(
    "$_global_ssh_hosts[@]"
    "$_ssh_hosts[@]"
    "$_etc_hosts[@]"
    "$HOST"
    localhost
  )
  zstyle ':completion:*:hosts' hosts $hosts
fi

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH/cache/

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

# Modify cd command tab completion to prioritize local directories and only show directories in the current directory.
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:cd:*' file-patterns '*(/)'
cdpath=(.)

# Use substring completion by default
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Use case-insensitive completion for all commands
zstyle ':completion:*' ignore-case true

# Set colors for ls completion
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Use "ps -u [user]" to list processes for completion
zstyle ':completion:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# Bind the accept-and-infer-next-history widget to "^o"
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*' ignored-patterns 'mount_*' 'ignore_*'
