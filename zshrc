[ -f "/etc/zshrc" ] && source /etc/zshrc

export PATH="${PATH}:${HOME}/bin:/opt/local/bin:/usr/local/go/bin"

# Editor and shell keybindings
export EDITOR=vim
export VISUAL=vim
bindkey -e	# EMACS-style key bindings

# Shell history
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=5000
export SAVEHIST=${HISTSIZE}
export APPEND_HISTORY=1
setopt hist_ignore_all_dups	# ignore duplicates
setopt hist_ignore_space	# don't log commands preceded with a space
# setopt share_history   		# share history across terminals

# Set prompt
PROMPT='%(?.%B%F{green} ok%b.%F{red}%?)%f %(!.%F{red}.)%n@%m %1~%f%# '

# General aliases
alias history="history 1"	# make like bash
alias astm='tmux attach||tmux'
alias fixssh='export $(tmux showenv SSH_AUTH_SOCK)' # fix ssh inside tmux

# Mac-specific configurations
if [ $(uname) = "Darwin" ]; then
	/usr/bin/ssh-add -A 2>/dev/null		# load all SSH keys
	alias df="df -Ph"			# suppress inode counts
	# Fancy ports upgrade
	alias upgrade-installed='port sync && port upgrade outdated && port uninstall inactive'
fi

# Debian/Ubuntu-specific configurations
if [ -f /etc/debian_version ]; then
	# Make upgrading software a bit easier
	alias upgrade-installed='sudo apt-get -y update && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove'
fi

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

	# add K8s helpers
	function kc() {
		plume_siteid=$(${HOME}/mesa/tools/iggy.sh sites list 2>/dev/null | grep plume-sim | awk '{print $1}')
		if [ "${plume_siteid}" ]; then
			$(${HOME}/mesa/k8s/sites/kubectl-config.sh -s  ${plume_siteid}) $*
		else
			echo "Plume site does not appear to be running" >&2
		fi
	}

	LAVABIN="${HOME}/mesa/go/bin/linux_amd64/lava"
	alias dlava="LAVA_ENDPOINT=https://dev.iggy.bz $LAVABIN"
	alias slava="LAVA_ENDPOINT=https://staging.iggy.bz $LAVABIN"
	alias plava="LAVA_ENDPOINT=https://cloud.iggy.bz $LAVABIN"
	alias lava="$LAVABIN"

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

	# Auto shutdown
	export SCHEDULE_NAME=PST
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
