# List of paths to search when looking
# for a command to execute.
# Looks in order, from first to last.
# $PATH is the default system path.

setupMyPATH() {
  # Path Variable Constructor
  # first directory with a given tool
  # will be used for that tool - order matters
  local pathDirs=(
    # HomeBrew
    /opt/homebrew/bin/
    /opt/homebrew/opt/sqlite/bin
    # System
    /usr/local/bin
    /usr/sbin
    /usr/bin
    /sbin
    /bin
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
  local manpathDirs=(
    /opt/homebrew/opt/gnu-sed/libexec/gnuman
    /opt/homebrew/opt/gnu-tar/libexec/gnuman
    /opt/homebrew/opt/findutils/libexec/gnubin
    /opt/homebrew/opt/coreutils/libexec/gnubin
  )

  for dir in $manpathDirs
  do
    myMANPATH+=":$dir" # add our own directories to the system $PATH variable
  done
}; setupMANPATH

MANPATH=$myMANPATH:$MANPATH # add my manpath before system MANPATH