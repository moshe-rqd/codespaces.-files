#!/bin/sh
sudo mkdir --verbose --parents --mode=+t,a=rwx -- /logs/bootstrap

mkdir --verbose --parents -- ~/{config,data}/zsh
cp --verbose --reflink=auto --archive -t ~/config/zsh/ -- ./config/zsh/*
mkdir --verbose --parents /etc/zsh/
sudo install --verbose --mode=o=r -t /etc/zsh ./zshenv

exec ./bootstrap.zsh
