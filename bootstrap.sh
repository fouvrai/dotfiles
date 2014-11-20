#!/usr/bin/env zsh

# set our default xdg config path, but only if it's not already set
[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z $XDG_CACHE_HOME ]]  && export XDG_CACHE_HOME="$HOME/.cache"

# a simple function to indent a command's output
indent() {
    eval $@ |& sed 's/^/  /'
}

# check if our config directory contains our dotfiles repo
if [[ -d $XDG_CONFIG_HOME/.git ]]; then
    # make sure it's up to date
    echo "Updating dotfiles repo in $XDG_CONFIG_HOME"
    pushd $XDG_CONFIG_HOME
    indent git pull
    indent git submodule update --init --recursive
    popd
else
    # clone it
    echo "Cloning dotfiles repo to $XDG_CONFIG_HOME"
    indent git clone --recursive https://github.com/fouvrai/dotfiles $XDG_CONFIG_HOME
fi

# symlink all the appropriate files
echo
echo "Setting up symlinks in $HOME"

for file in $XDG_CONFIG_HOME/**/*.symlink; do
    local home_file=$HOME/.$(basename "${file%.symlink}")

    if [[ ! -f $home_file ]]; then
        ln -s $file $home_file
    else
        indent echo "File '$home_file' already exists."
    fi
done

# we're done with our indent function now
unfunction indent

echo
echo "Launching ZSH"
exec zsh
