source ~/.env
source ~/.alias
source "${HOME}/.zgen/zgen.zsh"
export PATH="$PATH:$(yarn global bin)"
alias mvim=/Applications/MacVim.app/Contents/MacOS/Vim
export PATH="$PATH":"$HOME/.pub-cache/bin:$HOME/.anyenv/bin"
export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
export CLOUDSDK_PYTHON=/usr/bin/python2.7

if ! zgen saved; then
  zgen oh-my-zsh
  zgen oh-my-zsh themes/gallifrey

  zgen load zsh-users/zsh-completions src
  zgen load mollifier/cd-gitroot
  zgen load b4b4r07/enhancd
  zgen save
fi

set bell-style none
# ビープを鳴らさない
setopt nobeep
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
setopt hist_ignore_dups
export TERM=xterm-256color

plugins=(git laravel5 wp-cli docker docker-compose)
autoload -U compinit && compinit

# export SASS_LIBSASS_PATH=/Users/rootcom/libsass
export PATH=/usr/local/bin:$HOME/.rbenv/bin:$HOME/bin:/$HOME/sassc/bin:/usr/local/bin:$PATH:~/.composer/vendor/bin:~/AWS-ElasticBeanstalk-CLI-2.6.3/eb/macosx/python2.7:/usr/local/lib/node_modules/casperjs/node_modules/phantomjs/lib/phantom/bin:~/.bin:~/bin
export PATH=${PWD}/vendor/bin:${PWD}/vendor/bundle/bin:${PWD}/node_modules/.bin:$PATH

# eval "$(rbenv init -)"
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export PATH=$HOME/flutter/bin:$PATH
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

stty start undef
# # foobar
# # cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
# add-zsh-hook chpwd chpwd_recent_dirs

# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

#
function peco-cdr() {
  local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-cdr
bindkey '^o' peco-cdr

function peco-select-history() {
  local tac
  if which tac >/dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(\history -n 1 |
    eval $tac |
    peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function agvim() {
  ag "$@" | peco --query "$LBUFFER" | awk -F : '{print " " $1 " +" $2}' | xargs -o vi
}

fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _pm2_completion() {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
      COMP_LINE="$COMP_LINE" \
      COMP_POINT="$COMP_POINT" \
      pm2 completion -- "${COMP_WORDS[@]}" \
      2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _pm2_completion pm2
elif type compctl &>/dev/null; then
  _pm2_completion() {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
      COMP_LINE="$line" \
      COMP_POINT="$point" \
      pm2 completion -- "${words[@]}" \
      2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _pm2_completion + -f + pm2
fi

if type complete &>/dev/null; then
  _npm_completion() {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
      COMP_LINE="$COMP_LINE" \
      COMP_POINT="$COMP_POINT" \
      npm completion -- "${COMP_WORDS[@]}" \
      2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT - 1)) \
      COMP_LINE=$BUFFER \
      COMP_POINT=0 \
      npm completion -- "${words[@]}" \
      2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion() {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
      COMP_LINE="$line" \
      COMP_POINT="$point" \
      npm completion -- "${words[@]}" \
      2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi

autoload -U promptinit

function peco_kill() {
  for pid in $(ps -ef | peco | awk '{ print $2 }'); do
    kill $pid
  done
}
zle -N peco_kill
bindkey '^k' peco_kill
export PATH="/usr/local/opt/curl/bin:$PATH"
#source /usr/local/share/zsh/site-functions/_aws

if [ -f "${PWD}/venv/bin/activate" ]; then
  source $PWD/venv/bin/activate
fi

export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/fuji/google-cloud-sdk/path.zsh.inc' ]; then
  source '/Users/fuji/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/fuji/google-cloud-sdk/completion.zsh.inc' ]; then
  source '/Users/fuji/google-cloud-sdk/completion.zsh.inc'
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$HOME/.ndenv/bin:$PATH"
eval "$(ndenv init -)"
export PATH="/usr/local/opt/ruby/bin:$PATH"

for D in $(ls $HOME/.ndenv/shims); do
  export PATH="$HOME/.ndenv/shims:$PATH"
done
