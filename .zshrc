# Shell Config v0.0.1

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME="agnoster-modified"

# Use sublime as editor if it exists
if (command -v subl >/dev/null 2>&1;) then
  export EDITOR='subl -w'
fi

plugins=(git svn npm knife meteor vagrant mvn z sdkman zsh-syntax-highlighting zsh-autosuggestions)

source ~/.profile
source $ZSH/oh-my-zsh.sh

# Aliases
alias ccat="pygmentize -g"
alias zshrc="$EDITOR ~/.zshrc"

# Keybindings for cmd + delete and redo
bindkey "^U" backward-kill-line
bindkey "^X\\x7f" backward-kill-line
bindkey "^X^_" redo

# Syntax highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'

# Easier SSH with ops account
function sshops(){ ssh -o "StrictHostKeyChecking no" ops.tim.lindeberg@$1 }
function vagrantreload(){ vagrant destroy --force; vagrant up }
function vagrantp(){ vagrant provision --provision-with chef_solo }

# Show hidden files with cd
compinit
_comp_options+=(globdots)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/timlin/.sdkman"
[[ -s "/Users/timlin/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/timlin/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
