[ -f "/etc/zshrc" ] && source /etc/zshrc

export PATH="${PATH}:${HOME}/bin:/opt/local/bin:/usr/local/go/bin"

export EDITOR=vim
export VISUAL=vim

# Don't keep dupes in command history, as well as command prefaced by a
# space
export HISTCONTROL=ignoreboth

# If $HOME/.zsh doesn't exist, create it
[ -d "${HOME}/.zsh" ] || mkdir "${HOME}/.zsh"

# If I'm on an Igneous box...
if [ -x "${HOME}/mesa/tools/iggy.sh" ]; then
	# alias the iggy script properly...
	alias iggy="${HOME}/mesa/tools/iggy.sh"
	alias piggy="${HOME}/mesa/tools/iggy.sh -e https://cloud.igneous.io/"
	alias siggy="${HOME}/mesa/tools/iggy.sh -e https://staging.iggy.bz"
	alias diggy="${HOME}/mesa/tools/iggy.sh -e https://dev.iggy.bz"
	# Generate a new zsh completion file
	[ -d "${HOME}/.zsh" ] && "${HOME}/mesa/tools/iggy.sh" completion zsh > "${HOME}/.zsh/_iggy"

fi
	
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
fake_rgrep() {
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
[ "$(whence -w rgrep)" != "rgrep: none" ] || alias rgrep=fake_rgrep

# General stuff
bindkey -e	# EMACS-style key bindings
PROMPT='%(?.%B%F{green} ok%b.%F{red}%?)%f [%(!.%F{red}.)%n@%m%\] %1~%f%# '

# Autocompletion stuff I don't pretend to understand
fpath=(~/.zsh $fpath)
zstyle :compinstall filename '/Users/jonlasser/.zshrc'
autoload -Uz compinit
compinit
compdef _iggy iggy.sh	# use _iggy completion for all iggy.sh

# This supposedly has to be the last thing in the file
[ -d "${HOME}/src/zsh-syntax-highlighting" ] && \
	source "${HOME}/src/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# Just make the user's command bold. All the other syntax highlighting
# is kind of overwhelming, at least right now
ZSH_HIGHLIGHT_HIGHLIGHTERS=(line)
ZSH_HIGHLIGHT_STYLES[line]='bold'
