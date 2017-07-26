setopt auto_cd                  # ディレクトリ名と一致した場合 cd 
setopt autopushd
setopt pushd_ignore_dups        # 同じディレクトリは追加しない

PROMPT="[%B%~${default}%b] %E
%b%# "
RPROMPT='[%n@%m]'

alias u="cd ../"
alias ls="ls -gohvBG"
alias emacs="emacs-24.5"
chpwd() { clear;echo \[`pwd`\];ls}

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

export PATH=$PATH:/home/ragi/.cask/bin
alias rm="trash"

bindkey "^s" history-incremental-search-forward
bindkey "^r" history-incremental-search-backward

setopt noflowcontrol

export EDITOR=/usr/bin/vim

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
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"
export HOMEBREW_GITHUB_API_TOKEN="" 

### Virtualenvwrapper
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  export WORKON_HOME=$HOME/.virtualenvs
  source /usr/local/bin/virtualenvwrapper.sh
fi

. /Users/ichinari_sato/torch/install/bin/torch-activate
