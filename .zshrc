# Path to your oh-my-zsh installation.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

export ZSH="$DIR/.oh-my-zsh"

ZSH_THEME="agnoster-modified"

# Use sublime as editor if it exists
if (command -v subl >/dev/null 2>&1;) then
  export EDITOR='subl -w'
fi

plugins=(git svn npm knife meteor vagrant mvn z sdkman zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Keybindings for cmd + delete and redo
bindkey "^U" backward-kill-line
bindkey "^X\\x7f" backward-kill-line
bindkey "^X^_" redo

function chef-log() {
	less /var/log/chef/client.log
}

# Show hidden files with cd
_comp_options+=(globdots)


# Changes to another user but uses zsh instead of the users default shell and
# keeps this configuration.
function zshsu () {
	USER="$1"
	if [[ -z $USER ]]; then
		USER="root"
	fi
	sudo -u $USER ZDOTDIR="$DIR" zsh
}

alias tree="tree -C"

[ -f $DIR/.LS_COLORS ] && source $DIR/.LS_COLORS
[ -f $DIR/.zshrc-extra ] && source $DIR/.zshrc-extra
