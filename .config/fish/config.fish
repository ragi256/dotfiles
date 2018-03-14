set -gx SHELL /usr/local/bin/fish

# pyenv
set -gx PYENV_ROOT $HOME/.pyenv
set -gx PATH $PYENV_ROOT/shims $PATH
set -gx PATH $PYENV_ROOT/versions $PATH
status --is-interactive; and . (pyenv init -| psub)
eval (python -m virtualfish)

# go
set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# rust
set -gx PATH $HOME/.cargo/bin $PATH

# ghq
function ghq-new
    set -l root (ghq root)
    set -l user (git config --get github.user)
    if [ -z "$user" ]
        echo "you need to set github.user."
        echo "git config --global github.user YOUR_GITHUB_USER_NAME"
        return 1
    end
    set -l name $argv
    set -l repo "$root/github.com/$user/$name"
    echo $repo
    if [ -e "$repo" ]
        echo "$repo is already exists."
        return 1
    end
   git init $repo
    cd $repo
    touch README.md
    git add .
end

function fish_prompt
    set prompt (set_color green)(prompt_pwd)(set_color normal)"> "
    echo $prompt
    if set -q VIRTUAL_ENV
        echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
    end
end
