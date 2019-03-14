[ -f "/etc/bashrc" ] && source /etc/bashrc

export PATH="${PATH}:${HOME}/bin:/opt/local/bin:/usr/local/go/bin"

export EDITOR=vim
export VISUAL=vim

# Awesome color trick for bash: set color to yellow in our prompt, and
# use trap DEBUG to set it back before running the command in question.
#
# Unfortunately, this only seems to work on Bash 4.x and above -- or at
# least it's unreliable on the Bash 3.x versions used by Mac OS X.  (The
# failure mode is that it will usually work, but commands like 'cat y |
# grep x' end up hanging on the grep.)
if [ ${BASH_VERSINFO[0]} -ge 4 ]; then
	trap 'tput sgr0' DEBUG
	export PS1="\[$(tput sgr0)\]${PS1}\[$(tput bold setaf 11)\]"
fi

# If I'm on an Igneous box, alias the iggy script properly...
[ -x "${HOME}/mesa/tools/iggy.sh" ] && \
	alias iggy="${HOME}/mesa/tools/iggy.sh"
# ... and set my GOPATH
[ -x "${HOME}/mesa/go/" ] && export GOPATH="${HOME}/mesa/go/"
