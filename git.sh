#################
# Git Status & Info
#################

gs()  { git status; }
gl()  { git log --oneline "$@"; }
gll() { git log --graph --decorate --stat --all "$@"; }


#################
# Staging
#################

# Add files and show status
ga() {
  git add "$@"
  git status
}

# Unstage files
gu() {
  git reset HEAD "$@"
  git status
}

# Hard undo (discard changes)
ghu() {
  git reset HEAD "$@"
  git checkout .
}


#################
# Commits
#################

# Commit with message
gc()  { git commit -vm "$*"; }

# Commit all tracked files
gca() { git commit -va; }

# Add all + commit (quick commit)
gg()  { git commit -vam "$*"; }


#################
# Branches
#################

gb()  { git branch --column "$@"; }
gba() { git branch -a "$@"; }
gch() { git checkout "$@"; }
gm()  { git merge "$@"; }

# Setup tracking branch: gbt <remote> <branch>
gbt() {
  [[ -z "$2" ]] && { print "\n${RED}ERROR:${NC} gbt <remote> <branch>"; return 1; }
  git branch --track "$2" "$1/$2" && git checkout "$2"
}


#################
# Diffs
#################

gd()  { git difftool "$@"; }   # Kaleidoscope
gdm() { git diff master "$@"; }


#################
# Remotes
#################

gpl()  { git pull "$@"; }
gpsh() { git push "$@"; }
gnp()  { git-notpushed; }


#################
# Stash
#################

# Stash all changes (freeze)
gf() {
  git add .
  git stash
  git status
}

# Apply stash (unfreeze)
guf() { git stash apply; }


#################
# Repository Setup
#################

# Initialize repo
gi() {
  git init "$@"
  git status
}

# Clone from GitHub: gcl <repo>
gcl() {
  [[ -z "$1" ]] && { print "\n${RED}ERROR:${NC} gcl <repo-name>"; return 1; }
  git clone "git://github.com/$USER/$1.git"
}

# Add remote and push: gr <repo>
gr() {
  if [[ -z "$1" ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  Repo name missing"
    print "\n  ${GREEN}gr${NC} ${RED}<repo-name>${NC}"
    return 1
  fi
  git remote add origin "https://github.com/BabylonSix/$1.git"
  git push --set-upstream origin master
}

# Create bare repo on remote server: gitnew <repo>
gitnew() {
  [[ -z "$1" ]] && { print "\n${RED}ERROR:${NC} gitnew <repo-name>"; return 1; }
  ssh git@example.com "mkdir $1.git && cd $1.git && git --bare init"
  git remote add origin "git@example.com:$1.git"
  git push origin master
  git config branch.master.remote origin
  git config branch.master.merge refs/heads/master
  git config push.default current
}


#################
# File Operations
#################

# Discard file changes: grf <file>
grf() {
  [[ -z "$1" ]] && { print "\n${RED}ERROR:${NC} grf <file>"; return 1; }
  rm "$1"
  git checkout "$1"
}


#################
# Config
#################

egc() { subl .git/config; }
