# Manual steps:
#   * Set three finger drag under accessibility
#   * Set click to tap under trackpad
#   * Set real nature scroll direction under trackpad
#   * CMD + SHIFT + . in finder

if [ $# -eq 0 ] ; then
    echo "Pass email as first argument"
    exit 1
fi

EMAIL=$1
ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
CONFIG_DIR="$ICLOUD_DIR/Tim/Config"


function generate_ssh_key() {
	echo "Generating SSH key"

	SSH_DIR="$HOME/.ssh"
	SSH_KEY_FILE="$SSH_DIR/id_ed25519"
	SSH_CONFIG_FILE="$SSH_DIR/config"
	SSH_CONFIG_FILE_CONTENTS=$(cat <<END
Host github.com
	AddKeysToAgent yes
	UseKeychain yes
	IdentityFile ~/.ssh/id_ed25519
END
)
	if [ -f "$SSH_CONFIG_FILE" ]; then
		echo "$SSH_CONFIG_FILE exists, make sure it contains these lines"
		echo "$SSH_CONFIG_FILE_CONTENTS"
	else
		mkdir -p $SSH_DIR
		touch $SSH_CONFIG_FILE
		echo "Creating $SSH_CONFIG_FILE"
		echo "$SSH_CONFIG_FILE_CONTENTS" > $SSH_CONFIG_FILE
	fi

	if [ -f "$SSH_KEY_FILE" ]; then
		echo "$SSH_KEY_FILE already exists, make sure it's added etc."
	else
		ssh-keygen -t ed25519 -C "$EMAIL" -f $SSH_KEY_FILE
		eval "$(ssh-agent -s)"
		ssh-add --apple-use-keychain $SSH_KEY_FILE
	fi
}

function install_brew() {
	echo "Installing brew"

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
}

function install_casks() {
	echo "Installing casks"

	CASKS=(
		"google-chrome" 
		"iterm2" 
		"sublime-text" 
		"rectangle"
		"alt-tab"
		"visual-studio-code"
	)

	for CASK in ${CASKS[@]}; do
		echo "Installing $CASK"
		/opt/homebrew/bin/brew install $CASK --cask
	done
}

function install_cli_tools() {
	echo "Installing CLI tools"

	TOOLS=(
		"z"
		"lsd"
		"rg"
		"fd"
		"sd"
		"bat"
		"htop"
		"tldr"
		"duf"
		"diff-so-fancy"
		"fzf"
		"jq"
		"tre-command"
		"grc"
		"git-delta"
	)

	for TOOL in ${TOOLS[@]}; do
		echo "Installing $TOOL"
		/opt/homebrew/bin/brew install $TOOL
	done
}

function install_nvm_and_sdkman() {
	echo "Installing nvm"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	
	echo "Installing sdkman"
	curl -s "https://get.sdkman.io" | bash
}

function create_icloud_symlink() {
	echo "Creating iCloud symlink: $ICLOUD_DIR"

	ln -s "$ICLOUD_DIR" "$HOME/iCloud"
}

function install_oh_my_zsh() {
	echo "Setting up Oh my ZSH"

	OH_MY_ZSH_CUSTOM_DIR="$HOME/.oh-my-zsh/custom"

	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	git clone https://github.com/zsh-users/zsh-autosuggestions "$OH_MY_ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$OH_MY_ZSH_CUSTOM_DIR/plugins/fast-syntax-highlighting"
	ln -sf "$CONFIG_DIR/agnoster-modified.zsh-theme" "$OH_MY_ZSH_CUSTOM_DIR/themes/agnoster-modified.zsh-theme"

	rm "$HOME/.zshrc"
	ln -sf "$CONFIG_DIR/.zshrc" "$HOME/.zshrc"
	unzip "$CONFIG_DIR/SourceCodePro.zip" -d "/Library/Fonts"

	curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
}

function copy_plist_files() {
	echo "Copying plist files"

	cp -a "$CONFIG_DIR/plists/." "$HOME/Library/Preferences/"
}

function setup_git_config() {
	echo "Setting up git config"

	git config --global core.pager "delta"
	git config --global interactive.diffFilter "delta --color-only"
	git config --global color.ui true

	git config --global delta.navigate true
	git config --global delta.side-by-side true
	git config --global delta.line-numbers true
	git config --global delta.minus-style "syntax #96353c"
	git config --global delta.minus-emph-style "syntax #5c1f24"
	git config --global delta.plus-style "syntax #659c60"
	git config --global delta.plus-emph-style "syntax #3b5e38"

	git config --global diff.colorMoved default
	git config --global merge.conflictstyle diff3

	git config --global alias.pushfwl "push --force-with-lease"

	git config --global rerere.enabled true
	git config --global merge.conflictstyle zdiff3
	git config --global pull.rebase true
	git config --global push.autosetupremote true

	git config --global user.name "Tim Lindeberg"
	git config --global user.email "$EMAIL"
}


generate_ssh_key
install_brew
install_casks
install_cli_tools
install_nvm_and_sdkman
install_oh_my_zsh
create_icloud_symlink
copy_plist_files
setup_git_config
