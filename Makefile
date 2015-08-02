copy:
	# Vim
	cp ~/.vimrc .
	cp -r ~/.vim .

	# Git
	cp ~/.gitconfig .

	# Zsh
	cp ~/.zshrc .
	cp ~/.zpreztorc .
	cp ~/.zprofile .
	cp ~/.zshenv .
	cp ~/.zlogin .
	cp ~/.zlogout .

	# GPG Agent stuff
	# I wanna think about how to refactor this
	cp ~/.bash_gpg .
	mkdir .gnupg
	cp ~/.gnupg/gpg.conf .gnupg/
	cp ~/.gnupg/gpg-agent.conf .gnupg/

back:
	cp -r . ~
