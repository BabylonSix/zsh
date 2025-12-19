# File and Directory creation
f() { touch "$@"; }
d() { mkdir -pv "$@"; }
lns() { ln -s "$@"; }

md() {
  if [[ $# = 0 ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  No directory name provided"
    return 1
  fi
  mkdir -p "$1" && cd "$1" && l
}


# Open files | directories
o() { open .; }
of() { ot .; }
od() { ot .; }


# Take ownership of directory
sch() {
  if [[ -z "$1" ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  ${GREEN}sch${NC} ${RED}<path>${NC}"
    return 1
  fi
  print "${BLUE}→ Taking ownership of${NC} ${YELLOW}$1${NC}"
  sudo chown -R "$(whoami)":admin "$1"
  print "${GREEN}✓ Ownership changed${NC}"  # ← Add this line
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
srm() { trash "$@"; }


# Zip directory or file
zipr() {
  [[ -z "$1" ]] && { print "\n${RED}ERROR:${NC} zipr <file-or-dir>"; return 1; }
  zip -r "$1.zip" "$1"
}


# Directory display (use eza if available, fallback to ls)
if command -v eza &>/dev/null; then
  ls()   { eza "$@" --group-directories-first; } # eza globals
  l()    { clear; ls "$@" ; }
  la()   { clear; ls -a "$@"; }
  ll()   { clear; ls -lh "$@"; }
  lla()  { clear; ls -alh "$@"; }
  llg()  { clear; ls -lh --git-repos "$@"; }
  llga() { clear; ls -alh --git-repos "$@"; }
  lh()   { clear; ls -d .[^.]* "$@"; }
  llh()  { clear; ls -dlh repos .[^.]* "$@"; }
  lm()   { clear; ls -s modified "$@"; }
  llm()  { clear; ls -lhs modified "$@"; }
else
  ls()   { command ls -G "$@"; }
  l()    { clear; ls "$@"; }
  ll()   { clear; ls -lh "$@"; }
  la()   { clear; ls -A "$@"; }
  lla()  { clear; ls -Alh "$@"; }
  lh()   { clear; ls -d .[^.]* "$@"; }
  llh()  { clear; ls -dlh .[^.]* "$@"; }
  lm()   { clear; ls -t "$@"; }
  llm()  { clear; ls -lht "$@"; }
fi


# Directory tree
tree() { eza --tree --color=always --group-directories-first -I ".git|node_modules" "$@"; }
t() { tree "$@"; }
ta() { tree -a "$@"; }

td() { tree -L "$@"; }
tda() { tree -a -L "$@"; }

t2() { tl 2; }
t3() { tl 3; }
t4() { tl 4; }
t5() { tl 5; }
t6() { tl 6; }
t7() { tl 7; }
t8() { tl 8; }
t9() { tl 9; }

tll() { tree -l "$@"; }
tlla() { tll -a "$@"; }
tllg() { tll --git-repos --no-user --no-time --no-filesize "$@"; }
tllga() { tllg -a "$@"; }

# Directory navigation
b() { cd -; l; }

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
