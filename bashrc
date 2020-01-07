[ -f "/etc/bashrc" ] && source /etc/bashrc

export PATH="${PATH}:${HOME}/bin:/opt/local/bin:/usr/local/go/bin"

export EDITOR=vim
export VISUAL=vim

# Don't keep dupes in command history, as well as command prefaced by a
# space
export HISTCONTROL=ignoreboth

# Awesome color trick for bash: set color to yellow in our prompt, and
# use trap DEBUG to set it back before running the command in question.
#
# Unfortunately, this only seems to work on Bash 4.x and above -- or at
# least it's unreliable on the Bash 3.x versions used by Mac OS X.  (The
# failure mode is that it will usually work, but commands like 'cat y |
# grep x' end up hanging on the grep.)
if [ ${BASH_VERSINFO[0]} -ge 4 -a -n "${TERM}" ]; then
	trap 'tput sgr0' DEBUG
	export PS1="\[$(tput sgr0)\]${PS1}\[$(tput bold setaf 11)\]"
fi

# If I'm on an Igneous box, alias the iggy script properly...
[ -x "${HOME}/mesa/tools/iggy.sh" ] && \
	alias iggy="${HOME}/mesa/tools/iggy.sh"
	alias piggy="${HOME}/mesa/tools/iggy.sh -e https://cloud.igneous.io/"
	alias siggy="${HOME}/mesa/tools/iggy.sh -e https://staging.iggy.bz"
	alias diggy="${HOME}/mesa/tools/iggy.sh -e https://dev.iggy.bz"
	# set up command completion
	source /usr/share/bash-completion/bash_completion
	source <("${HOME}/mesa/tools/iggy.sh" completion bash)
# ... and set a couple of shell variables, especially $GOPATH
if [ -d "${HOME}/mesa/" ]; then 
	export PATH="${HOME}/mesa/go/bin:${PATH}"
	export GOPATH="${HOME}/mesa/go/"
	export GO11MODULE=off
	[ -d "${HOME}/mesa/go/src/igneous.io" ] && \
		export igsrc="${HOME}/mesa/go/src/igneous.io"
	if [ -d "/usr/src/go1.13.3/go/bin" ]; then
		export PATH="/usr/src/go1.13.3/go/bin:${PATH}"
		export GOLANG_VERSION=1.13.3
	elif [ -d "/usr/src/go1.12.5/bin" ]; then
		export PATH="/usr/src/go1.12.5/bin:${PATH}"
		export GOLANG_VERSION=1.12.5
	elif [ -d "/usr/local/go1.12/bin" ]; then
		export PATH="/usr/local/go1.12/bin:${PATH}"
		export GOLANG_VERSION=1.12
	elif [ -d "/usr/local/go/bin" ]; then
		export PATH="/usr/local/go/bin:${PATH}"
		# export GOLANG_VERSION=1.13.3
	fi
fi

# If I'm on a Mac, then I probably want to load all of my SSH keys
if [ $(uname) = "Darwin" ]; then
	/usr/bin/ssh-add -A 2>/dev/null
fi

# If rgrep doesn't exist, then alias one
which rgrep >/dev/null || rgrep() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: $FUNCNAME pattern [options] -- see grep usage"
        return
    # one arg - pattern
    elif [ "$#" -eq 1 ]; then
        grep -rn "$@" *;
    # 2 args - flag pattern
    elif [ "$#" -eq 2 ]; then
        first=$1
        shift
        grep -rn "$first" "$@" *;
    # more than 2 args
    else
        echo "Usage: $FUNCNAME 2+ params not yet supported"
        return
    fi
}
