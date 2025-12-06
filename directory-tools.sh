# File and Directory creation
alias f='touch'
alias d='mkdir -pv'
alias lns='ln -s'

md() {
  if [[ $# = 0 ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  No directory name provided"
    return 1
  fi
  mkdir -p "$1" && cd "$1" && l
}


# Open files | directories
alias o='open .'
alias of='ot .'
alias od='ot .'


# Take ownership of directory
sch() {
  if [[ -z "$1" ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  ${GREEN}sch${NC} ${RED}<path>${NC}"
    return 1
  fi
  sudo chown -R "$(whoami)":admin "$1"
}


# Choose disk volume
v() {
  if [[ -z "$1" ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  You did not enter a Disk Volume"
    print "\n${BLUE}Available volumes:${NC}"
    ls /Volumes
    return 1
  fi
  cd "/Volumes/$1" && l
}


# Safe deletion
alias srm='trash'


# Zip directory or file
zipr() { zip -r "$1.zip" "$1"; }


# Directory display (use eza if available, fallback to ls)
if command -v eza &>/dev/null; then
  alias l='clear; eza'
  alias ll='clear; eza -lh'
  alias la='clear; eza -a'
  alias lla='clear; eza -alh'
  alias lh='clear; eza -d .[^.]*'
  alias llh='clear; eza -dlh .[^.]*'
  alias lm='clear; eza -s modified'
  alias llm='clear; eza -lhs modified'
else
  alias ls='ls -G'
  alias l='clear; ls'
  alias ll='clear; ls -lh'
  alias la='clear; ls -A'
  alias lla='clear; ls -Alh'
  alias lh='clear; ls -d .[^.]*'
  alias llh='clear; ls -dlh .[^.]*'
  alias lm='clear; ls -t'
  alias llm='clear; ls -lht'
fi


# Directory tree
alias tree='tree -C'
alias t='tree -I "node_modules"'

tl() { tree -L "$@" -I "node_modules"; }

t2() { tl 2; }
t3() { tl 3; }
t4() { tl 4; }
t5() { tl 5; }
t6() { tl 6; }
t7() { tl 7; }
t8() { tl 8; }
t9() { tl 9; }

alias tll='tree -p'
alias tg='tree -g'
alias to='tree -u'
alias ta='tree -a -I ".git|node_modules"'
alias tlla='tree -ap -I ".git|node_modules"'


# Directory navigation
alias b='cd -; l'

u() { cd .. || return 1; l; }
u2() { cd ../.. || return 1; l; }
u3() { cd ../../.. || return 1; l; }
u4() { cd ../../../.. || return 1; l; }
u5() { cd ../../../../.. || return 1; l; }
u6() { cd ../../../../../.. || return 1; l; }
u7() { cd ../../../../../../.. || return 1; l; }
u8() { cd ../../../../../../../.. || return 1; l; }
u9() { cd ../../../../../../../../.. || return 1; l; }


# Show directory with ~ instead of /Users/$USER
sd() { pwd | sed -E "s|$HOME|~|"; }


# Yazi file manager (cd to directory on exit)
if command -v yazi &>/dev/null; then
  y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return 1
    yazi "$@" --cwd-file="$tmp"
    local cwd
    IFS= read -r cwd < "$tmp"
    rm -f -- "$tmp"
    [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd -- "$cwd" && l
  }
fi
