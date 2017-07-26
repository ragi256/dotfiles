# pyenv
set -gx PYENV_ROOT $HOME/.pyenv
set -gx PATH $PYENV_ROOT/bin $PATH
status --is-interactive; and . (pyenv init -| psub)

# go
set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH
