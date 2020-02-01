# File and Directory creation
alias f='touch $@'      # make a new file
alias d='mkdir -pv $@'  # make a new directory
alias lns='ln -s'       # create a symbolic link

md() {
if [[ $# = 0 ]]; then
	print '\n${RED}Error:${NC}'
	print '\n   No directory name provided'
else
	mkdir -p $1    # Create directory
	cd $1 || exit	 # CD into the newly created directory
fi
}


# Open files | directories
alias o='open .'
alias of='ot .' # open file | directory
alias od='ot .' # open file | directory


# take ownership of directory
sch() { sudo chown -R $(whoami):admin '$1'; }


# chose disk volume
v () {
if [[ -z $1 ]]; then # check if argument is empty
	print "\n${RED}ERROR:${NC}"
	print "\n  You did not enter a Disk Volume"
else
	/Volumes/$1
fi
}


# Safe Directory Destruction
alias srm='trash' # moves file to trash instead of instant deleting


# Zip Directory or file
zipr() { zip -r $1.zip $1; }


# Directory Display
alias ls='ls --color=always --group-directories-first -N --ignore=Icon'
alias l='clear; ls'               # 'ls' shorthand
alias ll='clear; ls -lh'          # long list (permisions, owner, size)
alias la='clear; ls -A'           # list all files (including hiddne files)
alias lla='clear; ls -Alh'        # long list of all files
alias lh='clear; ls -d .[^.]*'    # list all dotfiles
alias llh='clear; ls -dlh .[^.]*' # long list of all dotfiles
alias lm='clear; ls -t'           # sort with recently modified first
alias llm='clear; ls -lht'        # long list of recently modified files

# Directory Tree
alias tree='tree -C'              # set tree to always show colors
alias t='tree -I "node_modules"'  # shortcut for tree

tl() {
	# filter directory tree to '#a' levels deap
	# ignore node_modulesn folder
	tree -L "$@" -I "node_modules"
}

t2() { tl 2 }
t3() { tl 3 }
t4() { tl 4 }
t5() { tl 5 }
t6() { tl 6 }
t7() { tl 7 }
t8() { tl 8 }
t9() { tl 9 }

tll() {
	# tree long list
	tree -p
}

tg() {
	# tree group
	tree -g
}

to() {
	# tree owner
	tree -u
}

ta() {
	# tree display all
	tree -a -I ".git|node_modules"
}

tlla() {
	# tree long list all
	tree -ap -I ".git|node_modules"
}


# Directory Navigation
alias b='cd -; l' # toggle last & current directory


# move up x number of directories or fail gracefully
u() { cd .. || exit; l; }
u2() { cd ../.. || exit; l; }
u3() { cd ../../.. || exit; l; }
u4() { cd ../../../.. || exit; l; }
u5() { cd ../../../../.. || exit; l; }
u6() { cd ../../../../../.. || exit; l; }
u7() { cd ../../../../../../.. || exit; l; }
u8() { cd ../../../../../../../.. || exit; l; }
u9() { cd ../../../../../../../../.. ||exit; l; }


# show directory, but with ~/ instead of /Users/$user/
sd() {
  pwd | sed -E "s/\/Users\/$USER/~/g"
}