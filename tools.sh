#################
# Text Editors
#
export SUBLIME='Sublime Text'
export MSCODE='Visual Studio Code'
export NEOVIM=nvim

alias vim='nvim'
alias vi='nvim'

# Default Editor
export EDITOR=${MSCODE}

# Open in Default Editor
function ot() {
if [[ ${EDITOR} == nvim ]]; then
   ${EDITOR} $*
else
   open -a ${EDITOR} $*
fi
}


#################
# Browsers
#
export CHROME='Google Chrome'
export FIREFOX='Firefox'
export FIREDEV='Firefox Developer Edition'
export SAFARI='Safari'

# Default Browser
export BROWSER=${FIREDEV}


alias ob='open -a ${BROWSER}'

# JavaScript Mac Automation REPL
alias jsx='osascript -l JavaScript -i'

# Show ZSH Keyboard Shortcuts
alias kb='bindkey'

# Terminal
alias c='clear'
alias h='cd ~; l'
alias hi='history'

# Quiting Tasks
alias e='exit'
alias ka="killall -9" # kill a running program

# List Processes
alias tu='htop'

# find process X
fp() {
	ps ax | grep "$1"
}

# grep with color
alias grep='grep --color=always'
alias egrep='egrep --color=always'
alias ggrep='ggrep --color=always'

# print with color
alias print='print -P'


# youtube downloader
alias yt='yt-dlp'
alias yd='yt-dlp -f 137+140'
alias yv='yt-dlp -f 137'
alias yvl='yt-dlp -f 137+140 -a' # video playlist
alias yF='yt-dlp -F'
alias yf='yt-dlp -f'
# alias ya='yt-dlp --extract-audio --audio-format m4a'
alias ya='yt-dlp -f 140'
alias yu='sudo yt-dlp -U'

# mpv video player
alias mpv='mpv --no-border' # who needs borders!

# Dev environments
alias p3='python3'

# Multi Pane Utility
alias tm='tmux'
alias kt='killall -9 tmux'

# System Utilities
alias compare='ksdiff'      # Use Kaleidoscope to see differences in file content
alias chsh='chsh -s'        # Change Shell
alias chp='chmod'           # Change Permissions
cho() { chown $1; }         # Change Owners
alias mans='man -k'    		# search all man pages for key word
alias dul='diskutil'   		# disk utility

# List Tools
# first of list
alias fst='head -n 1'
# last of list
alias lst='tail -n 1'

# Check history of all downloads
alias chdh="sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'select LSQuarantineDataURLString from LSQuarantineEvent'"


# postgres color cli
sql() {
	# if number of entered arguments is 0
	if [[ $# -eq 0 ]]; then
		# error message
		clear
		print '\n${RED}ERROR:${NC}'
		print '\n  ${PINK}Database Name Missing!${NC}'
		print '\n  Run: ${RED}psql${NC} ${GREEN}<database-name>${NC} to run existing database'
		print '\n'
		
		# list existing databases that can be chosen
		pgcli --list

		print '\n'
		print '\n  ${PINK}To Manage Databases${NC}'
		print '\n  Run: ${RED}createdb${NC} ${GREEN}<database-name>${NC} to create new database'
		print '\n  Run: ${RED}dropdb${NC} ${GREEN}<database-name>${NC} to delete existing database'
	fi

	# if number of entered arguments is > 0
	if [[ $# -gt 0 ]]; then
		clear; pgcli --less-chatty --warn $1
	fi
}

# Reset Application Cache
rac() {
	# sudo -s
	lastDirectory=`pwd`
	sudo rm -rf /Library/Caches/com.apple.iconservices.store
	cd /Volumes/Macintosh\ HD/Library/Caches
	sudo rm -fr ./*
	cd /Volumes/Macintosh\ HD/System/Library/Caches
	sudo rm -fr ./*
	kextcache -system-prelinked-kernel
	kextcache -system-caches
	sudo -i kextcache -e
	cd /Volumes/Macintosh\ HD/Users/`whoami`/Library/Caches
	sudo rm -fr ./*
	cd $lastDirectory
	killall Dock
	killall Finder
}


# Networking
alias nw='networksetup'
alias nr='nw -setairportpower en1 off; nw -setairportpower en1 on' # restart network
alias nwr='nr'
alias nof='nw -setairportpower en1 off' # turn off network
alias non='nw -setairportpower en1 on'  # turn on network
alias nc='nc -v' # verbose + wait 3 seconds
alias bs='browser-sync'

bss() {
	# TODO:
	# • write test to check if current or
	#   entered directory has an index.html
	#   or index.pug file
	browser-sync start --server --files "./*"
}

# WebDev
alias sw='stylus --watch ./*.styl'
alias pw='pug -P --watch ./*.pug'

# kill named process
kn() {
	ps ax \
		| grep $1 \
		| cut -d ' ' -f 2 \
		| xargs kill;
}

us() {  # Update System

	# reset terminal device interface
	# prevents return key from not working sometimes
	stty sane


	# update brew and upgrade all packages
	print '\n${BLUE}Updating Brew${NC}\n'
	revolver --style 'pong' start 'checking for updates'
	brew update; brew upgrade
	revolver stop

	# upgrade node version
	print '\n\n\n\n${BLUE}Updating NVM${NC}'
	nvmup

	# update npm and upgrade all packages (global)
	print '\n\n\n\n${BLUE}Updating NPM${NC}\n'
	revolver --style 'pong' start 'checking for updates'
	npm update -g; npm upgrade -g
	print 'All NPM packages are up-to-date'
	revolver stop

	# erase global npmrc file
	if [[ -a ~/.npmrc ]]; then
	rm ~/.npmrc
	fi

	# System Resets
	print '\n\n\n\n${BLUE}System Resets${NC}\n'
	print 'Clear "Open With"'

	# Clears Open With
	alias cow='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'
	
	# Clear history of all downloads
	print 'Clear history of all downloads'
	alias cdh="sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

}



# show state of zsh options
alias zsho='set -o'



# RamDisk
ram() {
if (( $# < 1 )); then # if number of arguments is less than one
	print 'How many gigabytes in size'
	print 'do you want your ram storage to be?'
else
	gigabytes=$(($1*1024*2048))
	print $gigabytes
	diskutil erasevolume HFS+ 'RamDisk' `hdiutil attach -nomount ram://$gigabytes`
fi
}



#################
# Shell Tools
#

# disable std-out
disableOutput() {
	exec >/dev/null
	exec 2>/dev/null
}

# enable std-out
enableOutput() {
	exec >/dev/tty
	exec 2>/dev/tty
}

# count # of characters
# while ignoring newlines & tabs
charCount() {
	if [[ $# = 0 ]]; then
		local x=""
	else
		local x=$1
	fi
	print $x | perl -pe 's/(\n|\r|\t)//g' | wc -m
}



#################
# Wine Tools
#
setWine32Bit() {
	trash ~/.wine
	export WINEARCH=win32
}

setWine64Bit() {
	trash ~/.wine
	export WINEARCH=win64
}



#################
# Photo  Tools
#

# resize photos
resize-photos() {
	if [[ $# -lt 3 ]]; then
		print "${RED}Format:${NC} ${YELLOW}'${NC}>${YELLOW}'${NC} or ${YELLOW}'${NC}<${YELLOW}'${NC} ${YELLOW}'${NC}size${YELLOW}'${NC} ${YELLOW}'${NC}size${YELLOW}'${NC}"
	fi

	if [[ $# -gt 3 ]]; then
		print "${RED}Format:${NC} ${YELLOW}'${NC}>${YELLOW}'${NC} or ${YELLOW}'${NC}<${YELLOW}'${NC} ${YELLOW}'${NC}size${YELLOW}'${NC} ${YELLOW}'${NC}size${YELLOW}'${NC}"
	fi

	if [[ $# -eq 3 ]]; then
		echo "identify -format '%w %h %i\\\n' ./**/*.(jpg|jpeg|png) |
		awk '\$1 $1 $2 || \$2 $1 $2 {sub(/^[^ ]* [^ ]* /, \"\"); print}' |
		tr '\\\n' '\\\0' |
		xargs -0 mogrify -resize '$3'" | zsh
	fi
}

# check photo sizes and print list of jpg, jpeg, and png files
photo-sizes() {
	print '\n${RED}[dimensions]${NC}	${RED}[filename]${NC}'
	identify -format '%w x %h	%i\\\n' ./**/*.(jpg|jpeg|png)
}

# download gif
gif() {
	curl $1 --output ~/Desktop/$2.gif
}


#################
# VS Code Tools
#

# run C++ program
alias g++="print '\n\n\n'; clear; print '${GREEN}C++ Program${NC}\n'; g++-9"

# print machine code for c or c++ executable
alias mc="otool -tv"


#################
# Privacy Tools
#

# clean quicklook system cache
clean() {
	qlmanage -r cache
}