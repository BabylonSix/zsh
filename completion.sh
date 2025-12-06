# Completion Setup
# ZSH tab-completion behavior and styling

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol     # disable ctrl+s/ctrl+q flow control
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word  # complete from cursor position, not just end of word
setopt always_to_end     # move cursor to end after completion
setopt extendedglob      # enable advanced pattern matching

WORDCHARS=''             # treat special chars as word boundaries

zmodload -i zsh/complist # load completion list module


# Case-insensitive, partial-word, substring completion
# typing 'foo' matches 'Foo', 'FOO', 'foobar', 'barfoo', etc.
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:*:*:*' menu select # arrow keys navigate completion menu

bindkey -M menuselect '^o' accept-and-infer-next-history # ctrl+o accepts and continues


# Process completion (for kill, etc.)
# colors PIDs and shows process info
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $(whoami) -o pid,user,comm -w -w"


# CD: prefer local directories over global matches
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)


# Hostname completion from known_hosts and /etc/hosts
# pulls hostnames from SSH config for tab completion
[ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _global_ssh_hosts=()
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


# Caching
# speeds up completion for slow commands like apt, dpkg
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH/cache/


# Ignore system users
# don't show daemon accounts when completing usernames
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

zstyle '*' single-ignored show # show ignored match if it's the only one


# Optional: show dots while waiting for completion
# visual feedback during slow completions
if [ "x$COMPLETION_WAITING_DOTS" = "xtrue" ]; then
  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
fi
