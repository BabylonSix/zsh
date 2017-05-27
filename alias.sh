
# DotFile Settings
alias reload='source ~/bin/zsh/setup.sh'
alias r='reload; clear'

# System Settings
alias ehosts='sudo subl /etc/hosts'
alias eshells='sudo subl /etc/shells'
alias elint='subl ~/.eslintrc' # configure eslint

# Edit Config Files
alias ea='ot ~/bin/zsh/alias.sh && reload'
alias etools='ot ~/bin/zsh/tools.sh && reload'
alias et='etools'
alias escreen='ot ~/bin/zsh/screen.sh'
alias epath='ot ~/bin/zsh/path.sh' # edit $PATH
alias eshell='ot ~/bin/zsh/shell.sh'
alias ecolor='ot ~/bin/zsh/colors.sh'
alias edir='ot ~/bin/zsh/directory.sh'
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
alias hc='cd ~/Dropbox/Clients; l'
alias hs='cd ~/Studies; l'
alias hsw='cd ~/Studies/Web; l'
alias hw='cd ~/Clients/HyperNova/; l'
alias hp='cd ~/Personal\ Projects; l'
alias hpd='cd ~/Personal\ Projects/Daily\ Project; l'
alias hweb='cd ~/bin/web; l'
alias hzsh='cd ~/bin/zsh; l'
alias hvim='cd ~/bin/nvim; l'
alias hbin='cd ~/bin/; l'
alias hsub='cd ~/Library/Application\ Support/Sublime\ Text\ 3/; l'
alias hsublime='hsub'
