#################
# Text Editors
#################

export ZED='Zed'
export MSCODE='Visual Studio Code'
export NEOVIM='nvim'

alias vim='nvim'
alias vi='nvim'

# Default Editor
export EDITOR='Zed'

# Open in Default Editor
ot() {
  if [[ ${EDITOR} == "nvim" ]]; then
    ${EDITOR} "$@"
  else
    open -a "${EDITOR}" "$@"
  fi
}


#################
# Browsers
#################

export CHROME='Google Chrome'
export FIREFOX='Firefox'
export FIREDEV='Firefox Developer Edition'
export SAFARI='Safari'

# Default Browser
export BROWSER=${FIREDEV}

# Open in default browser (fix: function, not alias)
ob() {
  if [[ -z "$BROWSER" ]]; then
    print "${RED}ERROR:${NC} BROWSER is not set"
    return 1
  fi

  if [[ $# -eq 0 ]]; then
    # Just open the browser
    open -a "$BROWSER"
  else
    # Open files/URLs in the chosen browser
    open -a "$BROWSER" "$@"
  fi
}

# JavaScript Mac Automation REPL
alias jsx='osascript -l JavaScript -i'

# Show ZSH Keyboard Shortcuts
alias kb='bindkey'


#################
# Terminal & System
#################

alias c='clear'
alias h='cd ~; l'
alias hi='history'

# Quitting/Exiting
alias e='exit'
alias ka='killall -9'   # kill a running program

# Process Monitor
alias tu='btop'         # modern system monitor (replaces htop)

# find process X
fp() {
  ps ax | grep "$1"
}

# Print with prompt expansion (zsh-native)
alias print='print -P'


#################
# Modern Tools
#################

alias lg='lazygit'           # Git TUI
alias cat='bat'              # Better cat with syntax highlighting
alias grep='grep --color=always'

# FZF fuzzy finder (if installed)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Zoxide smart directory navigation (replaces z)
eval "$(zoxide init zsh)" 2>/dev/null || true


#################
# YouTube Downloader
#################

alias yt='yt-dlp'
alias yd='yt-dlp -f 137+140'
alias yv='yt-dlp -f 137'
alias yvl='yt-dlp -f 137+140 -a'  # video playlist
alias yF='yt-dlp -F'
alias yf='yt-dlp -f'
alias ya='yt-dlp -f 140'           # audio only
alias yu='sudo yt-dlp -U'          # update yt-dlp
alias ycc='yt-dlp --skip-download --write-subs --write-auto-subs --sub-langs "en.*,en" --convert-subs srt'
alias ysub='ycc'

# Video player
alias mpv='mpv --no-border'


#################
# Development
#################

alias p3='python3'
alias tm='tmux'
alias kt='killall -9 tmux'


#################
# System Utilities
#################

alias compare='ksdiff'       # Use Kaleidoscope for diffs
alias chsh='chsh -s'         # Change shell
alias chp='chmod'            # Change permissions

# Change owner (with syntax + feedback)
cho() {
  if [[ -z "$1" ]]; then
    print "${RED}ERROR:${NC} usage: cho <user> [path]"
    return 1
  fi

  local user="$1"
  local target="${2:-.}"

  print "${BLUE}→ Changing owner to ${YELLOW}${user}${NC} for ${YELLOW}${target}${NC}..."
  chown "$user" "$target"
  if [[ $? -eq 0 ]]; then
    print "${GREEN}✓ Ownership updated${NC}"
  else
    print "${RED}✗ Failed to change owner${NC}"
    return 1
  fi
}

alias mans='man -k'          # Search man pages
alias dul='diskutil'         # Disk utility


#################
# List Tools
#################

alias fst='head -n 1'        # First of list
alias lst='tail -n 1'        # Last of list


#################
# Shell Utilities
#################

# Disable stdout & stderr
disableOutput() {
  exec >/dev/null
  exec 2>/dev/null
}

# Enable stdout & stderr
enableOutput() {
  exec >/dev/tty
  exec 2>/dev/tty
}

# Count characters (excluding newlines & tabs)
charCount() {
  if [[ $# = 0 ]]; then
    local x=""
  else
    local x=$1
  fi
  print "$x" | perl -pe 's/(\n|\r|\t)//g' | wc -m
}


#################
# Web Development
#################

alias sw='stylus --watch ./*.styl'     # Stylus watcher
alias pw='pug -P --watch ./*.pug'      # Pug template watcher


#################
# Privacy & Caching
#################

# Clean Quick Look cache
cleanQl() {
  qlmanage -r cache
}

# Reset application cache (system-wide)
rac() {
  local lastDirectory
  lastDirectory=$(pwd)

  print "${BLUE}→ Clearing application caches...${NC}"
  sudo rm -rf /Library/Caches/com.apple.iconservices.store

  print "${BLUE}→ Clearing system caches...${NC}"
  cd /Volumes/Macintosh\ HD/Library/Caches 2>/dev/null && sudo rm -fr ./* && cd - >/dev/null
  cd /Volumes/Macintosh\ HD/System/Library/Caches 2>/dev/null && sudo rm -fr ./* && cd - >/dev/null

  print "${BLUE}→ Rebuilding kernel cache...${NC}"
  kextcache -system-prelinked-kernel 2>/dev/null || true
  kextcache -system-caches 2>/dev/null || true

  print "${BLUE}→ Clearing user caches...${NC}"
  cd "/Volumes/Macintosh HD/Users/$(whoami)/Library/Caches" 2>/dev/null && sudo rm -fr ./* && cd - >/dev/null

  cd "$lastDirectory"

  print "${BLUE}→ Restarting Dock and Finder...${NC}"
  killall Dock 2>/dev/null || true
  killall Finder 2>/dev/null || true

  print "${GREEN}✓ Cache cleanup complete${NC}"
}


#################
# Network Utilities
#################

alias nw='networksetup'
alias nr='nw -setairportpower en1 off; nw -setairportpower en1 on'  # restart wifi
alias nwr='nr'
alias nof='nw -setairportpower en1 off'  # turn off wifi
alias non='nw -setairportpower en1 on'   # turn on wifi


#################
# Process Management
#################

# Kill named process (blunt hammer)
kn() {
  ps ax | grep "$1" | cut -d ' ' -f 2 | xargs kill
}


#################
# ZSH Options
#################

alias zsho='set -o'


#################
# RAM Disk
#################

ram() {
  if (( $# < 1 )); then
    print 'How many gigabytes in size do you want your ram disk to be?'
  else
    local gigabytes=$(($1 * 1024 * 2048))
    print "Creating ${1}GB RAM disk..."
    diskutil erasevolume HFS+ 'RamDisk' "$(hdiutil attach -nomount ram://$gigabytes)"
  fi
}


#################
# AI Tools
#################

# Launch ComfyUI (Stable Diffusion UI)
cui() {
  cd "$HOME/AI/ComfyUI" || {
    print "${RED}ERROR:${NC} ComfyUI directory not found at $HOME/AI/ComfyUI"
    return 1
  }

  print "${BLUE}→ Starting ComfyUI...${NC}"
  python3 ./main.py &

  print "${BLUE}→ Waiting for server...${NC}"
  sleep 3

  print "${BLUE}→ Opening web UI...${NC}"
  open -a "Google Chrome" http://127.0.0.1:8188 &
}

# Open AI Models Folder
oai() {
  cd "$HOME/AI/ComfyUI" || {
    print "${RED}ERROR:${NC} ComfyUI directory not found at $HOME/AI/ComfyUI"
    return 1
  }
  open .
}
