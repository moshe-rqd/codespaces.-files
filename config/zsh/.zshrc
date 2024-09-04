#CONSIDER: inlining
eval "$(atuin init zsh)" || exit 1


export TERMINFO="${XDG_DATA_HOME}/terminfo"


setopt Auto_CD Auto_PushD
setopt Glob_Dots Extended_Glob
### let me do rm ~/releases/**
### e.g `**.rs` => `**/*.rs`, `***.rs` => `***/*.rs`, `**/foo` unchanged
setopt Glob_Star_Short
setopt Multi_OS
### must use `foo >! bar` instead of `foo > bar`, where file `bar` exists
setopt No__Clobber
setopt Interactive_Comments
### allows for e.g. `{abcdef0-9}` to expand to `0 1 2 3 4 5 6 7 8 9 a b c d e f`. Note the switched order - expansions are per ASCII value!
setopt Brace_CCL
### makes it so e.g. `p --foo=~` returns `--foo=/"$HOME"` instead of returning `--foo=~`. I've been missing this!
setopt Magic_Equal_Subst
### e.g. prints $'zsh: exit 1\n' when the program exits 1, $'zsh: exit 42\n' when the program exits with code 42, and so on for any non-zero exit
setopt PRINT_EXIT_VALUE
### makes it so completion appends a slash to directories - useful for the semantic information
setopt Mark_Dirs

export HISTFILE="$XDG_STATE_HOME/zsh.hist"
### the highest amount ZSH supports (2 ^ 63 - 1)
export HISTSIZE=9223372036854775807
export SAVEHIST="$HISTSIZE"
setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY
setopt NO__HIST_IGNORE_ALL_DUPS
setopt NO__HIST_IGNORE_SPACE


READNULLCMD=bat

PROMPT="%F{236}[%F{91}${LINENO}%F{236}]%k %F{57}(%(?.%F{green}${pipestatus}.%F{1}${pipestatus})%F{57}%) %B%F{7}|%F{118}%~%k%f|%b%K{233} %F{14}%# %k"


autoload -U compinit zargs zcalc

fpath+=("$ZDOTDIR/completions")

compinit


### holy hell is it annoying not having case-insensitive tab completion... This enables it
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'


#NOTE: we trim the final newline, as keeping it is incredibly annoying - it makes it autoenter into the terminal or whatever
kill-whole-buffer-to-system-clipboard () { wl-copy --trim-newline <<< "$BUFFER" && BUFFER="" }
zle -N kill-whole-buffer-to-system-clipboard

edit-command-line--emacs() { EDITOR='emacsclient --alternate-editor=  --tty' edit-command-line }
zle -N edit-command-line--emacs


#### keybindings
	#= <delete>
	bindkey '^[[3~' delete-char
	#= M-<delete>
	#: delete current word from cursor to the right boundary (there does not appear to be a keybinding to just.. kill the entire current word - both sides of it, I mean)
	bindkey '^[[3;3~' kill-word

	#= M-r
	#; jump backward to previous instance of the next pressed character
	bindkey '\er' vi-find-prev-char
	#= M-s
	#; jump forward to next instance of the next pressed character
	#NOTE: was bound to spell-word
	bindkey '\es' vi-find-next-char

	#= M-c
	bindkey '\ec' kill-whole-buffer-to-system-clipboard
	
	#= <f5>
	bindkey '^[[15~' redisplay

	#= C-x e e
	bindkey '^Xee' edit-command-line--emacs


### the only global alias needed, takes advantage of a space-ending alias expanding the next word as an alias to expand an alias anywhere by prefixing it with a word of `$` (e.g. `print foo bar $ baz qux`` will print `foo bar ` then the value of the alias `baz`, and then ` qux`)
alias -g '$= '


# alias btm='btm --network_use_binary_prefix --config-location="${XDG_CONFIG_HOME}/bottom/btm_config.toml"'

#### self-aliases, setting default flags
	alias btrfs='btrfs --verbose'
	alias cat='bat --paging=never'
	alias cargo='cargo auditable'
	alias chmod='chmod --verbose' # --changes
	alias cp='cp --reflink=auto --archive --verbose'
	alias delta='delta --hyperlinks --pager=bat\ -p'
	alias exa='exa --binary'
	alias grep='grep --color=auto'
	alias lfs='lfs --units binary'
	alias mkdir='mkdir --verbose'
	alias mount='mount --verbose'
	alias mpv='mpv --hwdec=auto --no-audio-display'
	alias mv='mv --debug'
	alias pkill='pkill --echo'
	alias rm='rm --verbose'
	alias umount='umount --verbose'
	alias wget="wget --hsts-file=${XDG_DATA_HOME}/wget-hsts"
#### aliases  effectively replacing the tool they alias
	alias rd='rmdir'
	alias plz='doas '
	alias py=python3
	alias xa='exa -aF'

alias pat='bat --paging=always'

alias trash='mv -b -t ~/trash/'

#### a few standard printing aliases, for both stdout and stderr
	alias pl='print -rl --'
	alias epl='print -rl -u 2 --'
	### printraw - print with no markup at all. Useful because herestrings not only don't expand shit, but add a newline too
	alias pr='print -rn --'
	alias epr='print -rn -u 2 --'

rgft1() { rg --only-matching --replace=\$1 "$@" }

### very much in muscle-memory, and so convenient besides
mcd() { mkdir "$@" && pushd "$@[-1]" }

einfo() {
	[[ $# -eq 1 ]] || return 64
	lhr emacs -nw --eval "(info \"$1\")"
}

eman() {
	[[ $# -eq 1 ]] || return 64
	lhr emacs -nw --eval "(man \"$1\")"
}

ewoman() { emacs -nw -q --eval $'(custom-set-variables \'(custom-enabled-themes \'(manoj-dark leuven)))' -f split-window-right -f other-window --eval "(woman \"$1\")" }

h(){"$@" --help | bat --language=help}

w() { which "$1" | bat -l zsh }

current_time() {
	case "$#" {
		   0) date --utc +'%Y-%m-%d--%H-%M-%S.%N'
		;; 1) case "$1" {
			   n(|ano)(|sec(|ond))(|s))  date --utc +'%Y-%m-%d--%H-%M-%S.%9N'
			;; micro(|seconds)|us) date --utc +'%Y-%m-%d--%H-%M-%S.%3N'
			;; milli(|seconds)|ms) date --utc +'%Y-%m-%d--%H-%M-%S.%3N'
			;; s|sec(|ond)(|s))     date --utc +'%Y-%m-%d--%H-%M-%S'
			#TODO: more as needed
			#TODO: make cases more consistent
			;; *)
				#### due to typical usage, instead of just aborting, we actually print some output, as putting nothing to STDOUT would likely be even worse than putting this compressed stuff
					date --utc +'%Y%m%d%H%M%S%N'
					epl "ERROR:current_time: invalid single-argument value: ${(q+)1}"
					return 64
		}
		#CONSIDER: accept timezone/offset
		;; *)
			#### due to typical usage, instead of just aborting, we actually print some output, as putting nothing to STDOUT would likely be even worse than  putting this compressed stuff
				date --utc +'%Y%m%d%H%M%S%N'
				epl "ERROR:current_time: expected zero or one argument (for now), got $# (args: ${(@q+)@})"
				return 64
	}
}


### queries the shell history database for commands matching the input, returning them as ndjson, syntax-highlighted and line-numbered for convenience (to strip the former, pipe through `strip-ansi-escapes` (from [the wezterm repo](https://github.com/wez/wezterm/tree/main/strip-ansi-escapes)), and the latter will no-op if piped into anything)
### pass input via $1 for a regex search (e.g. `histq '^emacs .+ --(eval|script)'`), or via stdin for a literal search (e.g. `histq <<<'firejail'`)
histq() {
	if [[ -n "$1" ]] {
		#WARNING: vulnerable to sql injection, but shouldn't matter, as this is intended to only be used locally by the user in an interactive fashion
		sqlite3 "$XDG_DATA_HOME/atuin/history.db" --json <<<"SELECT timestamp, duration, exit, command, cwd, session FROM history h WHERE h.command  REGEXP '$1'           ORDER BY h.timestamp DESC"
	} else {
 		#BORKED: still doesn't handle single quotes correctly (e.g. `histq <<<'histq <<<'\''galdl'\'` returns a parse error)
		sqlite3 "$XDG_DATA_HOME]/atuin/history.db" --json <<<"SELECT timestamp, duration, exit, command, cwd, session FROM history h WHERE h.command  == '${$(<&0)/'/''/}'  ORDER BY h.timestamp DESC"
	} \
	| jq -crC '
		#SRC(adapted): https://stackoverflow.com/a/46308382
		# input: milliseconds
		# output: ignore millisecond remainder
		def format_duration:
			def f(u): if .>0 then " \(.)" + u else "" end ;
			# emit a stream of the remainders
			def s: foreach (1000000000,60,60,24,1) as $i ([.,0];
				.[0] as $n
				| ($n/$i | floor) as $m
				| [$m, $n - ($m*$i)];
				if $i == 1 then .[0] else .[1] end);
			[s] as [$ms, $s, $m, $h, $d]
			| {s : " \($s)s",
				m : ($m|f("m")),
				h : ($h|f("h")),
				d : ($d|f("d")) }
			| "\(.d)\(.h)\(.m)\(.s)"[1:];
		.[] | {
			ran: (.timestamp / 1000000000 | todateiso8601),
			dur: (.duration | format_duration),
			ec: .exit,
			cmd: .command,
			cwd, sess: .session
		}'
}


exa__chpwd__hook() { exa --binary --classify --icons --all --color=always }
add-zsh-hook -Uz chpwd exa__chpwd__hook

#CONSIDER: some kind of codespace-triggerable codespace sync

alias xe='LD_LIBRARY_PATH=/usr/local/lib/ TERM=xterm-256color emacs-nw --debug-init'
