#!/bin/sh
#### this file is a minimal shim, written in portable (highly-restricted) shell syntax, intended to just set up what's needed by ZSH itself to function before `exec`'ing into ZSH for the remainder of the installation

sudo mkdir --verbose --parents --mode=+t,a=rwx -- /logs/bootstrap

. zshenv

mkdir --verbose --parents /etc/zsh/
sudo install --verbose --mode=o=r -t /etc/zsh ./zshenv

mkdir --verbose --parents -- "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$ZDOTDIR"
#NOTE: wildcards weren't working here, whatever shell it was exec'ing with (perhaps some garbage around the awful hack that .files are...)
cp --verbose --reflink=auto --archive -t "$ZDOTDIR" -- ./config/zsh/.zshrc ./config/zsh/.zshenv

exec ./setup.zsh
