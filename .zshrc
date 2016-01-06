#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

WHICH="/usr/bin/which"

# Source Prezto.
if test -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
if test -f "${HOME}/.secrets"
then
	source "${HOME}/.secrets"
fi
# Lines marked with a comment: {secret} are intended to be got from the above
# file.

# Because anon rate limiting
export HOMEBREW_GITHUB_API_TOKEN=GITHUB_API_TOKEN # {secret}
export MACHINE_GITHUB_API_TOKEN=GITHUB_API_TOKEN  # {secret}

# Docker machine stuff
if "${WHICH}" -s docker-machine && "${WHICH}" -s jq
then
	if docker-machine ls -q --filter "name=local" | grep -q local
	then
		local MACHINE_NAME="local"
		local ENV_COMMAND="docker-machine env"
		local CONFIG="${HOME}/.docker-machine.conf"
		if [ -f "${CONFIG}" ]
		then
			source "${CONFIG}"
			local IP="$(docker-machine inspect ${MACHINE_NAME} | jq -r .Driver.IPAddress)"

			if [ "${DOCKER_HOST#tcp://}" != "${IP}" ]
			then
				${ENV_COMMAND} "${MACHINE_NAME}" > "${CONFIG}"
				source "${CONFIG}"
			fi
		else
			${ENV_COMMAND} "${MACHINE_NAME}" > "${CONFIG}"
			source "${CONFIG}"
		fi
	fi
fi


# Go!
export GOPATH="${HOME}/gowork"
export PATH="${PATH}:${GOPATH}/bin"

# Gpg agent stuff
if "${WHICH}" -s gpg-agent
then
	local GPG_AGENT=$(which gpg-agent)
	GPG_TTY=`tty`
	export GPG_TTY
	local envfile="${HOME}/.gnupg/gpg-agent.env"
	local GPG_PID=''
	if test -f "${envfile}"
	then
		GPG_PID="$(grep GPG_AGENT_INFO "${envfile}" | cut -d: -f2)"
	fi

	if test -f "${envfile}" && kill -0 "${GPG_PID}" 2>/dev/null
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

# Pyenv
if "${WHICH}" -s pyenv
then
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# Rbenv
if "${WHICH}" -s rbenv
then
	eval "$(rbenv init -)"
fi

# Fuck
alias fuck='eval $(thefuck --alias)'

# In-terminal highlighting
if "${WHICH}" -s source-highlight-esc.sh
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
if "${WHICH}" -s src-hilite-lesspipe.sh
then
	export LESSOPEN="| $(which src-hilite-lesspipe.sh) %s"
	export LESS=' -R '
fi

# Google Cloud SDK block
{
	local GC='google-cloud-sdk'

	# Prefer to use local sdk, otherwise check for cask
	if test -d "${HOME}/${GC}"
	then
		GC="${HOME}/${GC}"
	elif test -d "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/${GC}"
	then
		GC="/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/${GC}"
	fi

	# The next line updates PATH for the Google Cloud SDK.
	if test -f "${GC}/path.zsh.inc"
	then
		source "${GC}/path.zsh.inc"
	fi

	# The next line enables shell command completion for gcloud.
	if test -f "${GC}/completion.zsh.inc"
	then
		source "${GC}/completion.zsh.inc"
	fi
}

# Vi mode, change <ESC> timeout from 0.4s to 0.1s
export KEYTIMEOUT=1
