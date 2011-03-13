tmux_man_for() {
	local key value

	declare -A context_to_man=(
		[bash]=shell
		[conf]=admin
		[help]=vim
		[mail]=mutt
		[sh]=shell
		[müzik]=mocp
		[music]=mocp
		[posta]=mutt
		[sohbet]=weechat-curses
		[chat]=weechat-curses
	)

	key=$1; [ -n "$key" ] || key=$TMUX_CONTEXT

	value=${context_to_man[$key]}

	[ -n "$value" ] || value="$key"

	echo "$value"
}

tmux_prog_for() {
	local key value

	declare -A context_to_prog=(
		[bash]=bash
		[sh]=${SHELL:-bash}
	)

	key=$1; [ -n "$key" ] || key=$TMUX_CONTEXT

	value=${context_to_prog["$key"]}

	[ -n "$value" ] || value=$(tmux_man_for "$key")
	[ -n "$value" ] || value="$key"

	echo "$value"
}

tmux_get_context() {
	local title context

	if [ $# -gt 0 ]; then
		title="$*"
	elif [ -n "$TMUX_CURRENT_TITLE" ]; then
		title="$TMUX_CURRENT_TITLE"
	else
		title=$(tmux display -p '#W' 2>/dev/null ||:)
	fi

	unset TMUX_CONTEXT TMUX_CONTEXT_IS_VIM

	case "$title" in
	\[*\]*)
		TMUX_CONTEXT_IS_VIM=yes
		context=${title%]*}
		context=${context##[}
	;;
	*)
		context=${title##*/}
	;;
	esac

	TMUX_CONTEXT="$context"
}

tmux_window_for() {
	local progname

	progname="$1"

	tmux list-windows |
	while read line; do
		num=${line%%:*}

		name="$line"
		# numarayı çıkar
		name=${name#*:}
		# yerleşimi çıkar
		name=${name%[*}
		# geometriyi çıkar
		name=${name%[*}
		# boşlukları sil
		name="${name// /}"

		tmux_get_context "$name"

		case "$(tmux_prog_for)" in
		${progname}*)
			echo "$num"
			break
		;;
		esac
	done
}

tmux_get_context
