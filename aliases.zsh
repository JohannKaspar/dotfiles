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
alias gl="git log --oneline --decorate --color"
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


workon() {
    local project_name="$1"
    local projects_file="$HOME/.projects"
    local project_dir

    # Check for projects config file
    if [[ ! -f "$projects_file" ]]; then
        echo "Error: $projects_file not found" >&2
        return 1
    fi

    # Get the project directory for the given project name
    project_dir=$(grep -E "^$project_name\s*=" "$projects_file" | sed 's/^[^=]*=\s*//' | sed 's/^[[:space:]]*//' | tr -d '\n')  # TODO make this cleaner

    # Ensure a project directory was found
    if [[ -z "$project_dir" ]]; then
        echo "Error: Project '$project_name' not found in $projects_file" >&2
        return 1
    fi

    # Ensure the project directory exists
    if [[ ! -d "$project_dir" ]]; then
        echo "Error: Directory $project_dir does not exist" >&2
        return 1
    fi

    # Change directories
    cd "$project_dir"
    source .venv/bin/activate  # TODO account for other venv locations
}

# uv
venv() {
    local venv_name
    local dir_name=$(basename "$PWD")

    # If there are no arguments or the last argument starts with a dash, use dir_name
    if [ $# -eq 0 ] || [[ "${!#}" == -* ]]; then
        venv_name="$dir_name"
    else
        venv_name="${!#}"
        set -- "${@:1:$#-1}"
    fi

    # Create venv using uv with all passed arguments
    if ! uv venv --seed --prompt "$@" "$venv_name"; then
        echo "Error: Failed to create venv" >&2
        return 1
    fi

    # ADDED THIS
    source .venv/bin/activate  # TODO account for other venv locations

    # Append to ~/.projects
    echo "${venv_name} = ${PWD}" >> ~/.projects
}