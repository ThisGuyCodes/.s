#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if test -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM=screen-256color

# Declare all the variables
declare -ra SECRETS=(
GITHUB_PUBLIC_TOKEN
DRONE_SERVER
DRONE_TOKEN
)

for NAME in ${SECRETS[@]}
do
	declare ${NAME}
done

# Customize to your needs...
if test -f "${HOME}/.secrets"
then
	source "${HOME}/.secrets"
fi
# Variables from the above file should not be checked in
# But they *should* be checked *for*
for NAME in ${SECRETS[@]}
do
	NAME="${NAME#\n}"
	# Ignore the blank lines at the head and tail
	if [ -z "${NAME}" ]
	then
		continue
	else
		NAME="${NAME#\n}"
	fi

	eval local CONTAINED=\$${NAME}
	if [ -z "${CONTAINED}" ]
	then
		# Warn that the value is missing
		echo "Secrets file is missing: ${NAME}"
	fi
done

# Because anon rate limiting
export HOMEBREW_GITHUB_API_TOKEN="${GITHUB_PUBLIC_TOKEN}"
export MACHINE_GITHUB_API_TOKEN="${GITHUB_PUBLIC_TOKEN}"

# Exported secrets
export DRONE_SERVER
export DRONE_TOKEN

# I work to make things here conditional, but I often get confused when stuff
# isn't working. Provide a means to alert on missing things, and to install
# said missing thins.
function _alert_missing {
	local MISSING="${1}"
	shift
	local INSTALL="${1}"
	shift
	local MESSAGE="${1}"

	if [ -n "${MESSAGE}" ]
	then
		echo "${MESSAGE}"
	else
		echo "${MISSING} is missing, adding install command to autofile (${INSTALL})"
	fi

	echo "${INSTALL}" >>! "${HOME}/.auto_install"
}

function install-missing {
	while read line
	do
		if ! eval "${line}"
		then
			echo "${line}" >>! "${HOME}/.auto_install.new"
		fi
	done < "${HOME}/.auto_install"
	if [ -f "${HOME}/.auto_install.new" ]
	then
		echo 'Some installations failed, run again to re-attempt the failed ones'
	fi
}

# Find if we're in an NPM project:
function _get_npm_project {
	local CHECKING="$(pwd)"
	while [ "${CHECKING}" != "/" ]
	do
		if [ -f "${CHECKING}/package.json" ]
		then
			echo "${CHECKING}"
			break
		else
			# Go up a level
			CHECKING="${CHECKING}/.."
			# Resolve...
			CHECKING="${CHECKING:A}"
		fi
	done
}

function _get_npm_package_path {
	local NPM_PROJECT="$(_get_npm_project)"
	if [ -n "${NPM_PROJECT}" ]
	then
		echo "${NPM_PROJECT}/node_modules/.bin"
	fi
}

local NPM_PACKAGE_PATH="$(_get_npm_package_path)"
function _fix_npm_package_path {
	# Maybe do nothing
	local NEW_PATH="$(_get_npm_package_path)"
	if [ "${NEW_PATH}" = "${NPM_PACKAGE_PATH}" ]
	then
		return
	fi
	# Escape for sed
	local ESCAPED_PATH="$(echo "${NPM_PACKAGE_PATH}" | sed -e 's/[\/&]/\\&/g')"
	local TMP_PATH=""
	# Remove existing path if any
	while true
	do
		# Beginning
		TMP_PATH="$(echo "${PATH}" | sed -e "s/^${ESCAPED_PATH}://")"
		if ! [ "${TMP_PATH}" = "${PATH}" ]
		then
			break
		fi
		# Middle
		TMP_PATH="$(echo "${PATH}" | sed -e "s/:${ESCAPED_PATH}:/:/")"
		if ! [ "${TMP_PATH}" = "${PATH}" ]
		then
			break
		fi
		# End
		TMP_PATH="$(echo "${PATH}" | sed -e "s/:${ESCAPED_PATH}$//")"
		if ! [ "${TMP_PATH}" = "${PATH}" ]
		then
			break
		fi
		# None
		TMP_PATH="${PATH}"
		break
	done

	NPM_PACKAGE_PATH="${NEW_PATH}"

	# Add the correct one, only if there is a path
	if [ -n "${NPM_PACKAGE_PATH}" ]
	then
		TMP_PATH="${TMP_PATH}:${NPM_PACKAGE_PATH}"
	fi
	export PATH="${TMP_PATH}"
}

# Add to the chpwd functions
chpwd_functions=(${chpwd_functions[@]} "_fix_npm_package_path")

# Docker machine stuff
if which docker-machine >/dev/null && which jq >/dev/null
then
	if docker-machine ls -q --filter "name=local" | grep -q local
	then
		local MACHINE_NAME="local"
		local CONFIG="${HOME}/.docker-machine.conf"
		if [ -f "${CONFIG}" ]
		then
			source "${CONFIG}"
			local IP="$(docker-machine inspect ${MACHINE_NAME} | jq -r .Driver.IPAddress)"

			if [ "${DOCKER_HOST#tcp://}" != "${IP}" ]
			then
				docker-machine env "${MACHINE_NAME}" >! "${CONFIG}"
				source "${CONFIG}"
			fi
		else
			docker-machine env "${MACHINE_NAME}" > "${CONFIG}"
			source "${CONFIG}"
		fi
	fi
else
	if ! which docker-machine >/dev/null
	then
		_alert_missing "docker-machine" "brew install docker-machine"
	fi
	if ! which jq >/dev/null
	then
		_alert_missing "jq" "brew install jq"
	fi
fi


# Go!
export GOPATH="${HOME}/gowork"
export PATH="${PATH}:${GOPATH}/bin"

# pcscd scdaemon pcsc-tools
# Gpg agent stuff
if which gpg-agent > /dev/null
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

	if test -f "${envfile}"
	then
		eval "$(cat "${envfile}")"
	else
		SSH_AUTH_SOCK=''
	fi
	if test ! -S "${SSH_AUTH_SOCK}"
	then
		local GPG_PIDS="$(ps -x -U "${UID}" | grep '/[g]pg-agent' | awk '{print $1}')"
		xargs kill <<< "${GPG_PIDS}" &> /dev/null
	    	eval "${GPG_AGENT} --daemon --log-file=~/.gnupg/gpg.log" >! "${envfile}"
		eval "$(cat "${envfile}")"
	fi
	# The env file does not contain the export statement
	export SSH_AUTH_SOCK
else
	_alert_missing "gpg-agent" "brew install gpg-agent"
fi

# Pyenv
if test -d "${HOME}/.pyenv/bin"
then
	export PATH="${HOME}/.pyenv/bin:${PATH}"
fi
if which pyenv > /dev/null
then
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
else
	_alert_missing "pyenv" "brew install pyenv pyenv-virtualenv"
fi

# Rbenv
if [[ "${PATH}" != *"${HOME}/.rbenv/bin"* ]] && [ -d "${HOME}/.rbenv" ]
then
	export PATH="${PATH}:${HOME}/.rbenv/bin"
fi
if which rbenv > /dev/null
then
	eval "$(rbenv init -)"
fi

# Fuck
which thefuck &>/dev/null && eval "$(thefuck --alias)"

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
else
	_alert_missing "source-highlight" "brew install source-highlight"
fi
if which src-hilite-lesspipe.sh > /dev/null
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

FZF_TMUX=0

[ -d "${HOME}/.chefdk/gem/ruby/2.1.0/bin" ] && PATH="${PATH}:${HOME}/.chefdk/gem/ruby/2.1.0/bin"
[ -e "/etc/zsh_command_not_found" ] && source "/etc/zsh_command_not_found"

# Simple completion includes
local INCLUDES=(
	"${HOME}/.fzf.zsh"
	'/usr/local/bin/aws_zsh_completer.sh'
	"${HOME}/.iterm2_shell_integration"
)
for f in ${INCLUDES}
do
	if test -f "${f}"
	then
		source "${f}"
	fi
done

if which yarn &>/dev/null
then
	export PATH="${PATH}:$(yarn global bin)"
fi

alias vi=nvim
alias vim=nvim
