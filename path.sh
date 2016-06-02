# List of paths to search when looking
# for a command to execute.
# Looks in order, from first to last.
# $PATH is the default system path.

# Set PATH Variable
PATH=$PATH:\
/bin:\
/sbin:\
/usr/bin:\
/usr/sbin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/local/cellar:


path() { $SHELL -lc 'echo $PATH | tr : "\n"'; } # display path variable

ts() { $SHELL -lc 'echo hello'; } # use this guy for debugging the path file
