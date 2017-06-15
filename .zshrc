# Shell Config v0.0.1

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

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

# Syntax highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'


# Show hidden files with cd
compinit
_comp_options+=(globdots)

if [ -d "~/.zshrc-extra" ]; then
  source "~/.zshrc-extra"
fi
