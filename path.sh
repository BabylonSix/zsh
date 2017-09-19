# List of paths to search when looking
# for a command to execute.
# Looks in order, from first to last.
# $PATH is the default system path.


setupMyPATH() {
  # Path Variable Constructor
  pathDirs=(
    # START activate gnu-utils first
    /usr/local/opt/coreutils/libexec/gnubin
    /usr/local/opt/findutils/libexec/gnubin
    /usr/local/opt/gnu-tar/libexec/gnubin
    /usr/local/opt/gnu-sed/libexec/gnuman
    # END activate gnu-utils first
    /bin
    /sbin
    /usr/local/bin
    /usr/bin
    /usr/sbin
    /usr/local/sbin
    /usr/local/Cellar
    # EXTRA Tools TEMP
    ~/.nvm/versions/node/$(node --version)/bin
    /opt/X11/bin
    /usr/local/var/pyenv/shims
    #Haskell
    ~/.local/bin
  )

  for dir in $pathDirs
  do
    myPATH+=":$dir" # add our own directories to the system $PATH variable
  done
}; setupMyPATH

unset PATH # clear PATH Variable before setting it 
PATH=$myPATH:$PATH # add my path before system PATH


# TOOLS
path() { $SHELL -lc 'echo $PATH | tr : "\n"'; } # display path variable
manpath() { $SHELL -lc 'echo $MANPATH | tr : "\n"'; } # display manpath variable



# setup MANPATH variable
setupMANPATH() {
  manpathDirs=(
    /usr/local/opt/gnu-sed/libexec/gnuman
    /usr/local/opt/gnu-tar/libexec/gnuman
    /usr/local/opt/findutils/libexec/gnubin
    /usr/local/opt/coreutils/libexec/gnubin
  )

  for dir in $manpathDirs
  do
    myMANPATH+=":$dir" # add our own directories to the system $PATH variable
  done
}; setupMANPATH

MANPATH=$myMANPATH:$MANPATH # add my manpath before system MANPATH



manpath() { $SHELL -lc 'echo $MANPATH | tr : "\n"'; } # display manpath variable
