
# DotFile Settings
alias reload='source ~/bin/zsh/setup.sh'
alias r='reload; clear'

# System Settings
alias ehosts='ot /etc/hosts'
alias eshells='ot /etc/shells'
alias elint='ot ~/.eslintrc' # configure eslint

# Edit Config Files
alias ea='ot ~/bin/zsh/alias.sh && reload'
alias etools='ot ~/bin/zsh/tools.sh && reload'
alias et='etools'
alias escreen='ot ~/bin/zsh/screen.sh'
alias epath='ot ~/bin/zsh/path.sh' # edit $PATH
alias eshell='ot ~/bin/zsh/shell.sh'
alias ecolor='ot ~/bin/zsh/colors.sh'
alias edir='ot ~/bin/zsh/directory-tools.sh'
alias edirs='ot ~/bin/zsh/directories.sh'
alias enpm='ot ~/bin/zsh/node-setup.sh'
alias essh='ot ~/bin/zsh/ssh.sh'
alias esetup='ot ~/bin/zsh/setup.sh'
alias ebin='ot ~/bin/'
alias egit='ot ~/bin/zsh/git.sh'
alias esublime='ot ~/Library/Application\ Support/Sublime\ Text\ 3'
alias esub='esublime'
alias ep='eprojects'
alias eweb='ot ~/bin/web/'
alias ezsh='ot ~/bin/zsh/'
alias eprojects='ot ~/bin/web/projects.sh'
alias esj='ot ~/bin/web/sj/'
alias evim='ot ~/bin/nvim/settings.vim'

# Directory Shortcuts
alias hd='cd ~/Desktop; l'
alias hl='cd ~/Downloads; l'
alias hc='cd ~/Library/Mobile Documents/com~apple~CloudDocs/My Files/Clients; l'
alias hs='cd ~/Studies; l'
alias hsw='cd ~/Studies/Web; l'
alias hp='cd ~/Personal\ Projects; l'
alias hpd='cd ~/Personal\ Projects/Daily\ Project; l'
alias hweb='cd ~/bin/web; l'
alias hzsh='cd ~/bin/zsh; l'
alias hvim='cd ~/bin/nvim; l'
alias hbrew='cd /opt/homebrew/Cellar; l'