
# Sets Default text editor: Sublime Text 3
export EDITOR='subl -w'

# Show ZSH Keyboard Shortcuts
alias kb='bindkey'

# Terminal
alias c='clear'
alias h='cd ~; l'
alias hi='history'

# Quiting Tasks
alias e='exit'
alias ka="killall -9"		# kill a running program

# List Processes
alias tu='htop'

# grep with color
alias grep='grep --color=always'

# print with color
alias print='print -P'


# youtube downloader
alias y='youtube-dl'
alias yd='youtube-dl -f 137+140'
alias yv='youtube-dl -f 137'
alias yvl='youtube-dl -f 137+140 -a ' # video playlist
alias yF='youtube-dl -F'
alias yf='youtube-dl -f'
alias ya='youtube-dl -f 140'
alias yal='youtube-dl -f 140 -a ' # audio playlist
alias yu='sudo youtube-dl -U'


# Dev environments
alias p3='python3'

# Multi Pane Utility
alias tm='tmux'
alias kt='killall -9 tmux'

# System Utilities
alias compare='ksdiff'      # Use Kaleidoscope to see differences in file content
alias chsh='chsh -s'        # Change Shell
alias chp='chmod'           # Change Permissions
cho() { chown $1; }          # Change Owners
alias mans='man -k'    			# search all man pages for key word
alias dul='diskutil'   			# disk utility


# Check history of all downloads
alias chdh="sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'select LSQuarantineDataURLString from LSQuarantineEvent'"



# Networking
alias nw='networksetup'
alias nr='nw -setairportpower en1 off; nw -setairportpower en1 on' # restart network
alias nwr='nr'
alias nof='nw -setairportpower en1 off' # turn off network
alias non='nw -setairportpower en1 on'  # turn on network



# kill named process
kn() { ps ax | grep $1 | cut -d ' ' -f 2 | xargs kill; }



us() { # Update System
	# update brew and upgrade all packages
	brew update; brew upgrade
	# update npm and upgrade all packages (global)
	npm update -g; npm upgrade -g
	# Clears Open With
	alias cow='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'
	# Clear history of all downloads
	alias cdh="sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
}



# RamDisk
ram() {
if [[ -z $1 ]]; then       # check if argument is empty
	print 'How many gigabytes in size'
	print 'do you want your ram storage to be?'
else
	gigabytes=$(($1*1024*2048))
	print $gigabytes
	diskutil erasevolume HFS+ 'RamDisk' `hdiutil attach -nomount ram://$gigabytes`
fi
}
