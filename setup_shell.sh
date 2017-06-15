VERSION=0.0.1
VERBOSE=true

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GIT_URL="https://github.com/timlindeberg/ShellConfig"
REPO_LOCATION="/tmp/ShellConfig-master"

RED='e\033[0;31m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
CLEAR='\033[0m'

#set -x

function loginfo() {
	[ "$VERBOSE" = true ] && echo "$MAGENTA$1$CLEAR"
}

function logsuccess() {
	[ "$VERBOSE" = true ] && echo "$GREEN$1$CLEAR"
}

function logerror() {
	[ "$VERBOSE" = true ] && echo "$RED$1$CLEAR"
	exit 1
}

function install_oh_my_zsh() {
	if [ ! -d "$HOME/.oh-my-zsh" ];
	then
		loginfo "Installing oh-my-zsh"
		curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
		if [ $? -ne 0 ]; then
			logerror "Failed to install oh-my-zsh."
		fi
		logsuccess "Installed oh-my-zsh"
	else
		loginfo "oh-my-zsh is already installed"
	fi	
}

function deploy_zhsrc() {
	if !(grep "Shell Config v$VERSION" "$HOME/.zshrc";) then
		loginfo "Updating .zshrc"
		download_config_repo
		cp "$REPO_LOCATION/.zshrc" "$HOME/.zshrc"
	else
		loginfo ".zshrc is up to date"
	fi 	
}

function deploy_agnoster_theme() {
	if !(grep "Shell Config v$VERSION" "$HOME/.zshrc";) then
		loginfo "Updating .zshrc"
		download_config_repo
	else
		loginfo ".zshrc is up to date"
	fi 
}

function download_config_repo() {
	if [ -d "$REPO_LOCATION" ] 
	then
		return 1
	fi
	loginfo "Downloading repo" 
	cd /tmp
	curl -LOk --progress-bar "$GIT_URL/archive/master.zip"
	tar -xzf master.zip
}

function install_program() {
	PROGRAM=$1
	if !(command -v $PROGRAM >/dev/null 2>&1;) then
		loginfo "Installing $PROGRAM"
		echo "$PASSWORD" | sudo -S yum -y install $PROGRAM > /dev/null 2>&1
		if [ $? -ne 0 ]; then
			logerror "Failed to install $PROGRAM."
		fi
		logsuccess "Installed $PROGRAM"
	else
		loginfo "$PROGRAM is already installed"
	fi	
}

#download_config_repo
install_program git
install_program zsh
#install_oh_my_zsh
deploy_zhsrc