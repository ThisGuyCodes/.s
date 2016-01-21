copy:
	# Vim
	cp ~/.vimrc .
	mkdir -p .vim
	# Colors
	cp -r ~/.vim/colors .vim/
	# Lockfile
	mkdir -p .vim/bundle
	cp ~/.vim/bundle/NeoBundle.lock .vim/bundle
	cp ~/.vim/package.json .vim
	cp ~/.vim/npm-shrinkwrap.json .vim

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
	mkdir -p .gnupg
	cp ~/.gnupg/gpg.conf .gnupg/
	cp ~/.gnupg/gpg-agent.conf .gnupg/

back:
	rsync --exclude-from './rsync-exclude.txt' -r . ~
