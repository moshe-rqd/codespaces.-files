export XDG_BIN_HOME="$HOME/bin"
export PATH="$XDG_BIN_HOME:$PATH"

#DISABLED: codespaces seem to have these set already (under /usr/local)
	# export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
	# export CARGO_HOME="${XDG_DATA_HOME}/cargo"
	# export PATH="$CARGO_HOME/bin:$PATH"

export LESSHISTFILE="$XDG_STATE_HOME"/less/history

export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

export SQLITE_HISTORY="$XDG_STATE_HOME"/sqlite_history

export W3M_DIR="$XDG_DATA_HOME"/w3m

export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"

export PYENV_ROOT="$XDG_DATA_HOME"/pyenv

export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
