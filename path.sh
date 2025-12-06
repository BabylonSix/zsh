# List of paths to search when looking
# for a command to execute.
# Looks in order, from first to last.
# $PATH is the default system path.

setupMyPATH() {
  # Path Variable Constructor
  # first directory with a given tool
  # will be used for that tool - order matters
  local pathDirs=(
    # Homebrew
    /opt/homebrew/bin
    /opt/homebrew/sbin
    /opt/homebrew/opt/sqlite/bin
    # System
    /usr/local/bin
    /usr/sbin
    /usr/bin
    /sbin
    /bin
  )

  for dir in $pathDirs; do
    myPATH+=":$dir" # add our own directories to the system $PATH variable
  done
}
setupMyPATH

unset PATH # clear PATH Variable before setting it
PATH=$myPATH:$PATH # add my path before system PATH


# TOOLS
path() {
  # display PATH, one entry per line
  $SHELL -lc 'echo $PATH | tr : "\n"'
}
