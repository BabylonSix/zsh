# List of paths to search when looking
# for a command to execute.
# Looks in order, from first to last.
# $PATH is the default system path.


setupPATH() {
  # Path Variable Constructor
  pathDirs=(
    /bin
    /sbin
    /usr/bin
    /usr/sbin
    /usr/local/bin
    /usr/local/sbin
    /usr/local/cellar
    /usr/local/opt/gnu-sed/libexec/gnuman
    /usr/local/opt/gnu-tar/libexec/gnubin
    /usr/local/opt/findutils/libexec/gnubin
    /usr/local/opt/coreutils/libexec/gnubin
  )

  for dir in $pathDirs
  do
    PATH+=":$dir" # add our own directories to the system $PATH variable
  done
}; setupPATH


path() { $SHELL -lc 'echo $PATH | tr : "\n"'; } # display path variable

ts() { $SHELL -lc 'echo hello'; } # use this guy for debugging the path file
