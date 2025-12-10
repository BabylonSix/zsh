#		ssh-keygen
#		# add meaningful identifier
#		~/.ssh/id_(domain)
#		# copy the public key
#		pbcopy < ~/.ssh/id_(domain).pub
#		# paste it into the domain ssh field and name it your machine
#
#		# add the private key into the keychain
#		ssh-add -K ~/.ssh/id_(domain)


# list all active ssh keys
sshl() { ssh-add -l; }

# add ssh key to keychain
ssha() { ssh-add --apple-use-keychain "$@"; }
