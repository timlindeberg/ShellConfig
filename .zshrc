ZSHRC_PATH="$(print -P %N)"
export ZSHRC_DIR="$( dirname "$ZSHRC_PATH" )"
export ZSH="$ZSHRC_DIR/.oh-my-zsh"

# Causes aliases to expand before sudo which allows aliases to be used with sudo
alias sudo='sudo '

export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

ZSH_THEME="agnoster-modified"

plugins=(git mvn z zsh-autosuggestions fast-syntax-highlighting pyenv)

# Nord color theme
LS_COLORS='no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*.sh=01;36:*.rb=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:'
export LS_COLORS
export USER_LS_COLORS=$LS_COLORS

export HIDE_HOST="true"

tabs -4
unsetopt beep

source "$ZSH/oh-my-zsh.sh"

# Use LS_COLORS for cd and other auto completes
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
# Show hidden files with cd
_comp_options+=(globdots)

# Use sublime as editor if it exists
if (command -v subl >/dev/null 2>&1;) then
  export EDITOR='subl -w'
else
  export EDITOR='vim'
fi

# Keybindings for cmd + delete and redo
bindkey "^U" backward-kill-line
bindkey "^X\\x7f" backward-kill-line
bindkey "^X^_" redo

function zshrc() {
  subl -w ~/.zshrc
  source ~/.zshrc
}

alias l="lsd -lah"
alias ls="lsd"
alias ltr="lsd -latr"
alias sed="sed -E"
alias glog='git log --oneline --decorate --graph --pretty=format:"%C(red)%C(bold)%h%Creset %Cblue%ad%Creset %an %C(bold)%Cgreen%s%Creset"'
alias gsu='git submodule update --init --recursive'
alias gupdate='git remote prune origin && git fetch && git pull && gsu'
alias gst='git status --ignore-submodules=all'
alias fd='fd --no-ignore'
alias rg='rg --no-ignore'

# Colorize man output
function _colorman() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;35m") \
    LESS_TERMCAP_md=$(printf "\e[1;34m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[7;40m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;33m") \
      "$@"
}
function man() { _colorman man "$@"; }

function zip_tree() {
  rm -rf tmp_zip_dir
  mkdir tmp_zip_dir
  tar -xzf $1 -C tmp_zip_dir
  tree tmp_zip_dir
  rm -rf tmp_zip_dir
}

function set_upstream() {
  BRANCH=`git rev-parse --abbrev-ref HEAD`
  git branch --set-upstream-to="origin/$BRANCH" $BRANCH
}

function git-latest() {
  git reflog | grep -o "checkout: moving from .* to " | sed -e 's/checkout: moving from //' -e 's/ to $//' | perl -ne 'print unless $seen{$_}++' | head -50
}

function git-from-master() {
  #git fetch
  FILE=$1
  DIR_NAME=$(dirname -- "$FILE")
  FILE_NAME=$(basename -- "$FILE")
  EXTENSION="${FILE_NAME##*.}"
  FILE_NAME="${FILE_NAME%.*}"
  git show "origin/master:${FILE}" > "${DIR_NAME}/${FILE_NAME}_master.${EXTENSION}"
}

# Enable grc commands

if [[ "$TERM" != dumb ]] && (( $+commands[grc] )) ; then
  cmds=(cc configure cvs df diff dig gcc gmake ifconfig last ldap make mount mtr netstat ping ping6 ps traceroute traceroute6 wdiff whois iwconfig);

  # Set alias for available commands.
  for cmd in $cmds ; do
    if (( $+commands[$cmd] )) ; then
      alias $cmd="grc --colour=auto $(whence $cmd)"
    fi
  done

  # Clean up variables
  unset cmds cmd
fi


[ -f $ZSHRC_DIR/.zshrc-extra ] && source $ZSHRC_DIR/.zshrc-extra

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  [ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

ssh-add --apple-use-keychain ~/.ssh/id_ed25519 &> /dev/null

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

