export XDG_BIN_HOME="$HOME/bin"
export PATH="$XDG_BIN_HOME:$PATH"

export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export PATH="$CARGO_HOME/bin:$PATH"

export LESSHISTFILE="$XDG_STATE_HOME"/less/history

export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

#REF(https://old.reddit.com/r/golang/comments/pi97sp/what_is_the_consequence_of_using_cgo_enabled0/hbo0fq6/): With CGO_ENABLED=0 you got a statically-linked binary
export CGO_ENABLED=0
export GOPATH="$XDG_DATA_HOME"/go

export SQLITE_HISTORY="$XDG_STATE_HOME"/sqlite_history

export W3M_DIR="$XDG_DATA_HOME"/w3m

export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"

export PYENV_ROOT="$XDG_DATA_HOME"/pyenv

export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel

export GNUPGHOME="$XDG_DATA_HOME"/gnupg

export ELINKS_CONFDIR="$XDG_CONFIG_HOME"/elinks

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
