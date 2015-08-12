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

# Go!
export GOPATH="${HOME}/gowork"
export PATH="${PATH}:${GOPATH}/bin"

# Gpg agent stuff
if which gpg-agent > /dev/null
then
	local GPG_AGENT=$(which gpg-agent)
	GPG_TTY=`tty`
	export GPG_TTY
	local envfile="${HOME}/.gnupg/gpg-agent.env"
	local GPG_PID
	if [ -f "${envfile}" ]
	then
		GPG_PID="$(grep GPG_AGENT_INFO "${envfile}" | cut -d: -f2)"
	fi

	if [ -f "${envfile}" ] && kill -0 "${GPG_PID}" 2>/dev/null
	then
	    eval "$(cat "${envfile}")"
	else
		local GPG_PIDS="$(ps -x -U "${UID}" | grep '/[g]pg-agent' | awk '{print $1}')"
		xargs kill <<< "${GPG_PIDS}" &> /dev/null
	    eval "$(${GPG_AGENT} --daemon --log-file=~/.gnupg/gpg.log --write-env-file "${envfile}")"
		eval "$(cat "${envfile}")"
	fi
	# The env file does not contain the export statement
	export GPG_AGENT_INFO
	export SSH_AUTH_SOCK
	export SSH_AGENT_PID
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
	local NEW_CAT="$(which source-highlight-esc.sh)"
	local OLD_CAT="$(which cat)"
	function cat() {
		if ! test -t 1
		then
			"${OLD_CAT}" $@
		elif ! "${NEW_CAT}" $@ 2>/dev/null
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

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]
then
	source "${HOME}/google-cloud-sdk/path.zsh.inc"
fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]
then
	source "${HOME}/google-cloud-sdk/completion.zsh.inc"
fi
