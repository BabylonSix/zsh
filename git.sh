# Git
alias gs='git status'

# git init command
function gi() {
	git init $@
	git status
}

# git add command
function ga() {
	git add $@
	git status
}

# git unstage command
function gu() {
	git reset HEAD $@
	git status
}

alias gb='git branch --column'
alias gba='git branch -a'
function gc() {
	git commit -vm "$*"
}
alias gca='git commit -va'

# Commit pending changes and quote all args as message
function gg() {
	git commit -vam "$*"
}
alias gco='git checkout'
# alias gdm='git diff master'
# alias gd='git diff' # The old way
alias gd='git difftool'        # Uses Kaleidoscope as the diff tool
alias gpl='git pull'
alias gnp="git-notpushed"
alias gpsh='git push'
alias egc='subl .git/config'

alias gl="git log --oneline"
alias gll='git log --graph --decorate --stat --all'
alias gch="git checkout"

# Git clone from GitHub
function gcl() {
	git clone git://github.com/$USER/$1.git
}

# Create a New Git Repo
function gr() {
  if [[ -z $1 ]]; then # check if argument is empty
    print '\n${RED}ERROR:${NC}'
    print '\n  Repo Name Missing!' # if argument is empty
    print '\n  ${GREEN}gr${NC} ${RED}<repo name>${NC}' # if argument is empty
  else
    git remote add origin https://github.com/BabylonSix/$1.git
    git push --set-upstream origin master
  fi
}

# stash (freeze) repo
function gf() {
  git add .
  git stash
  git status
}

# stash apply (unfreeze)
function guf() {
  git stash apply
}

# Setup a tracking branch from [remote] [branch_name]
function gbt() {
	git branch --track $2 $1/$2 && git checkout $2
}
# Quickly clobber a file and checkout
function grf() {
	rm $1
	git checkout $1
}
# Call from inside an initialized Git repo, with the name of the repo.
function new-git() {
	ssh git@example.com "mkdir $1.git && cd $1.git && git --bare init"
	git remote add origin git@example.com:$1.git
	git push origin master
	git config branch.master.remote origin
	git config branch.master.merge refs/heads/master
	git config push.default current
}
