#!/bin/bash
set -euo pipefail

function main() {
	local mac='/usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac'
	local other="$(which pinentry)"

	local dothis=''
	if test -x "${mac}"
	then
		dothis="${mac}"
	else
		dothis="${other}"
	fi

	exec "${dothis}" "${@}"
}

main
