#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
source "${HOME}/.secrets"

# Because anon rate limiting
export HOMEBREW_GITHUB_API_TOKEN # Declared in .secrets
export GOPATH="${HOME}/gowork"
export PATH="${PATH}:${GOPATH}/bin"

# gpg agent stuff
GPG_AGENT=$(which gpg-agent)
GPG_TTY=`tty`
export GPG_TTY

# I don't really like how this is in another file
if [ -f ${GPG_AGENT} ]; then
    . ~/.bash_gpg
fi

# Most of the boot2docker stuff, ip may change
export DOCKER_TLS_VERIFY=1
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=${HOME}/.boot2docker/certs/boot2docker-vm

# Pyenv
if which pyenv > /dev/null
then
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# Rbenv
if which rbenv > /dev/null
then
	eval "$(rbenv init -)"
fi

# Fuck
alias fuck='eval $(thefuck-alias)'

# In-terminal highlighting
if which source-highlight-esc.sh > /dev/null
then
	OLD_CAT="$(which cat)"
	function cat() {
		if ! "$(which source-highlight-esc.sh)" $@ 2>/dev/null
		then
			"${OLD_CAT}" $@
		fi
	}
fi
if which src-hilite-lesspipe.sh > /dev/null
then
	export LESSOPEN="| $(which src-hilite-lesspipe.sh) %s"
	export LESS=' -R '
fi
