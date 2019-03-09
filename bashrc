[ -f "/etc/bashrc" ] && source /etc/bashrc

export PATH="${PATH}:${HOME}/bin:/opt/local/bin:/usr/local/go/bin"

export EDITOR=vim
export VISUAL=vim

# Awesome color trick for bash: set color to yellow in our prompt, and
# use trap DEBUG to set it back before running the command in question.
trap 'tput sgr0' DEBUG
export PS1="\[$(tput sgr0)\]\h:\W \u\$ \[$(tput bold setaf 11)\]"
export PS1="\[$(tput sgr0)\]${PS1}\[$(tput bold setaf 11)\]"

# If I'm on an Igneous box, alias the iggy script properly
[ -x "${HOME}/mesa/tools/iggy.sh" ] && \
	alias iggy="${HOME}/mesa/tools/iggy.sh"
