[ -f "/etc/bashrc" ] && source /etc/bashrc

export PATH="${PATH}:/opt/local/bin:/usr/local/go/bin"

export EDITOR=vim
export VISUAL=vim

# Awesome color trick for bash: set color to yellow in our prompt, and
# use trap DEBUG to set it back before running the command in question.
trap 'tput sgr0' DEBUG
export PS1="\[$(tput sgr0)\]\h:\W \u\$ \[$(tput bold setaf 11)\]"
export PS1="\[$(tput sgr0)\]${PS1}\[$(tput bold setaf 11)\]"

# Suppress Vagrant warning message
export VAGRANT_USE_VAGRANT_TRIGGERS=1
