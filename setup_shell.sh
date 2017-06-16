VERSION="0.0.2"
VERBOSE=false

GIT_URL="https://github.com/timlindeberg/ShellConfig.git"
REPO_LOCATION="/tmp/ShellConfig"
THEMES_DIR="$HOME/.oh-my-zsh/themes"
ZSH_PLUGINS="$HOME/.oh-my-zsh/custom/plugins"

RED='e\033[0;31m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
CLEAR='\033[0m'

function loginfo() {
	[ "$VERBOSE" = true ] && echo "> $1"
}

function logsuccess() {	
	echo " ✓ $1"
}

function logerror() {
	echo " × $1"
	exit 1
}

function logresult() {
	NAME=$1
	if [ $? -ne 0 ]; then
		logerror "Failed to install $NAME."
	fi
	logsuccess "Installed $NAME"
}

function install_program() {
	PROGRAM=$1
	if command -v $PROGRAM >/dev/null 2>&1; then
		loginfo "$PROGRAM is already installed"
		return 0
	fi

	loginfo "Installing $PROGRAM"
	sudo -S yum -y install $PROGRAM
	logresult $PROGRAM
}

function install_zsh_plugin() {
	PLUGIN=$1
	if [ -d "$ZSH_PLUGINS/$PLUGIN" ]; then
		loginfo "$PLUGIN is already installed"
		return 0
	fi

	loginfo "Installing $PLUGIN"
	git clone https://github.com/zsh-users/$PLUGIN.git $ZSH_PLUGINS/$PLUGIN
	logresult $PLUGIN
}

function install_oh_my_zsh() {
	if [ -d "$HOME/.oh-my-zsh" ]; then
		loginfo "oh-my-zsh is already installed"
		return 0
	fi

	loginfo "Installing oh-my-zsh"
	curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
	logresult "oh-my-zsh"
}

function deploy_zhsrc() {
	if grep "Shell Config v$VERSION" "$HOME/.zshrc" >/dev/null 2>&1; then
		loginfo ".zshrc is up to date"
		return 0
	fi
	loginfo "Updating .zshrc"
	download_config_repo
	cp "$REPO_LOCATION/.zshrc" "$HOME"
	logsuccess "Updated .zshrc to v$VERSION"
}

function deploy_agnoster_theme() {
	if grep "Shell Config v$VERSION" "$THEMES_DIR/agnoster-modified.zsh-theme" >/dev/null 2>&1; then
		loginfo "agnoster-theme is up to date"
		return 0
	fi
	loginfo "Updating agnoster-theme"
	download_config_repo
	cp "$REPO_LOCATION/agnoster-modified.zsh-theme" "$THEMES_DIR"
	logsuccess "Updated agnoster-theme to v$VERSION"
}

function download_config_repo() {
	if [ -d "$REPO_LOCATION" ]; then
		return 0
	fi
	loginfo "Downloading Shell Config repo"
	git clone $GIT_URL $REPO_LOCATION
}


install_program git
install_program zsh
install_oh_my_zsh
install_zsh_plugin zsh-syntax-highlighting
install_zsh_plugin zsh-autosuggestions
deploy_zhsrc
deploy_agnoster_theme
rm -rf "$REPO_LOCATION" >/dev/null 2>&1
echo "Shell setup finished"
