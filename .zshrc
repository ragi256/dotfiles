setopt auto_cd                  # ディレクトリ名と一致した場合 cd 
setopt autopushd
setopt pushd_ignore_dups        # 同じディレクトリは追加しない

#--- zsh 用の設定 ---
. /usr/local/etc/autojump.zsh

# #--- cd 時の仕掛け ---
# function precmd () {
#     pwd=`pwd`
#     echo "[^[[35m$pwd^[[m]"
#     autojump -a $pwd
#     echo $pwd > ~/.curdir
# }

# function cdls() {
#     # cdがaliasでループするので\をつける
#     \cd $1;
#     ls;
# }

chpwd() { clear;echo \[`pwd`\];ls -gohvG }
PROMPT="[%B%~${default}%b] %E
%b%# "
RPROMPT='[%n@%m]'

#alias cd=cdls

alias u="cd ../"
alias ls="ls -gohvBG"
alias emacs="emacs-24.5"
#cd `cat ~/.cudir`

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=10000000

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


export PATH=$PATH:/Applications/Wine.app/Contents/Resources/bin

alias rm="trash"

bindkey "^s" history-incremental-search-forward
bindkey "^r" history-incremental-search-backward

setopt noflowcontrol

EDITOR=/usr/local/bin/emacs-24.5
export EDITOR

alias mv="mv -i"
alias cp="cp -i"


export PATH=$PATH:${HOME}/software/clang+llvm-3.5.0-macosx-apple-darwin/bin
export PATH=$PATH:/usr/local/Cellar/nmap/6.47/bin
export PATH=$PATH:/usr/local/Cellar/binutils/2.25/bin

export LANG=ja_JP.UTF-8
export XMODIFIERS=@im=uim
export GTK_IM_MODULE=uim
export UIM_CANDWIN_PROG="uim-candwin-gtk"

fpath=($(brew --prefix)/share/zsh/site-function $fpath)
autoload -U compinit
compinit -u

source dnvm.sh
