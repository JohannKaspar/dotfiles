# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias compile="commit 'compile'"
alias version="commit 'version'"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias projects="cd $HOME/Projects"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias watch="npm run dev"

# Docker
alias docker-composer="docker-compose"

# Git
alias gs="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --graph --oneline --decorate --color --all"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force-with-lease"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias prune="git fetch --prune"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"

# remote development
alias tunnel_jupyter="~/.dotfiles/scripts/tunnel_jupyter.sh"
alias tunnel_tensorboard="~/.dotfiles/scripts/tunnel_tensorboard.sh"
alias download="/Users/johannkaspar/.dotfiles/scripts/download_outputs.sh"

workon() {
    local project_dir="$HOME/Projects/$1"

    # Ensure the project directory exists
    if [[ ! -d "$project_dir" ]]; then
        echo "Error: Directory $project_dir does not exist" >&2
        echo "List of projects:"
        ls -1 "$HOME/Projects"
        return 1
    fi

    cd "$project_dir"
    source .venv/bin/activate
}

act() {
    # check if .venv exists in the current directory and activate it
    if [[ -d ".venv" ]]; then
        source .venv/bin/activate
    else
        echo "Error: No .venv directory found in the current directory" >&2
        return 1
    fi
}
