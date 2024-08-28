#!/bin/zsh
# set -e
exec 1>&1 2>&2 1>>/logs/bootstrap/combined 2>>/logs/bootstrap/combined 1>&1 1>>/logs/bootstrap/stdout 2>&2 2>>/logs/bootstrap/stderr || exit 1
die() {
	print -rl -u 2 -- "$2"
	exit "$1"
}

export RUSTFLAGS='-C target-cpu=native -C panic=unwind -C strip=none -C codegen-units=1 -C debuginfo=2 -C opt-level=3'

### we're bootstrapping cargo-auditable itself (because we want it to include its own audit info), so don't waste time optimizing the short-lived first stage
RUSTFLAGS='-C target-cpu=native' --profile=debug command cargo install --git=https://github.com/rust-secure-code/cargo-auditable cargo-auditable
[ "${aliases[cargo]}" = 'cargo auditable' ] || die 78 'cargo is not aliased to cargo auditable! something has gone wrong'
cargo install --git=https://github.com/rust-secure-code/cargo-auditable cargo-auditable

#CONSIDER: trimming features
cargo install --git=https://github.com/atuinsh/atuin atuin
[[ -v CODESPACES__ATUIN_PASSWORD ]] || die 72 'CODESPACES__ATUIN_PASSWORD not set in the environment'
[[ -v CODESPACES__ATUIN_KEY ]] || die 72 'CODESPACES__ATUIN_KEY not set in the environment'
[[ -n "$CODESPACES__ATUIN_PASSWORD" ]] || die 72 'CODESPACES__ATUIN_PASSWORD is empty'
[[ -n "$CODESPACES__ATUIN_KEY" ]] || die 72 'CODESPACES__ATUIN_KEY is empty'
atuin login --username=moshe-rqd --email=moshe@redqueendynamics.com --password="$CODESPACES__ATUIN_PASSWORD" --key="$CODESPACES__ATUIN_KEY"
# atuin import auto
atuin sync --force
atuin gen-completions --shell=zsh --out-dir="$ZDOTDIR/completions"

export TERMINFO="${XDG_DATA_HOME}/terminfo"
mkdir --verbose --parents "$TERMINFO"
sudo install --verbose --mode=o=r -- ./wezterm.terminfo "${TERMINFO}/wezterm"
