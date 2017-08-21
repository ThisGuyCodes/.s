copy:

	# Git
	cp ~/.gitconfig .

	# Zsh
	cp ~/.zshrc .
	cp ~/.zpreztorc .
	cp ~/.zprofile .
	cp ~/.zshenv .
	cp ~/.zlogin .
	cp ~/.zlogout .
	cp ~/.tmux.conf .

	# GPG Agent stuff
	# I wanna think about how to refactor this
	mkdir -p .gnupg
	cp ~/.gnupg/gpg.conf .gnupg/
	cp ~/.gnupg/gpg-agent.conf .gnupg/
	cp ~/.gnupg/pinentry.sh .gnupg/

back:
	rsync --exclude-from './rsync-exclude.txt' -r . ~
