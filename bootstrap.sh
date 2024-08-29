#!/bin/sh
sudo mkdir --verbose --parents --mode=+t,a=rwx -- /logs/bootstrap

source .zshenv

mkdir --verbose --parents -- "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"

mkdir --verbose --parents -- "$ZDOTDIR"

#NOTE: wildcards weren't working here
cp --verbose --reflink=auto --archive -t "$ZDOTDIR" -- ./config/zsh/.zshrc

mkdir --verbose --parents /etc/zsh/
sudo install --verbose --mode=o=r -t /etc/zsh ./zshenv

exec ./setup.zsh
