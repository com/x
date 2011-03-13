# Bir kabukta yerleşik olarak bulunmasını istediğimiz işlevler

# kabuk kitaplıkları için basit ithalat
use() {
	local n="$1" p m

	[ -n "$n" ] || return 0

	local oldifs="$IFS"; IFS=':'
	for p in ${SHLIB}; do
		for m in "${p}/${n}.sh" "${p}/${n}"; do
			if [ -r "$m" ]; then
				IFS="$oldifs"
				if [ -f "$m" ]; then
					. "$m"
				elif [ -d "$m" ]; then
					sourcedir "$m"
				fi
				return 0
			fi
		done
	done
	IFS="$oldifs"

	return 1
}

# verilen dizinde öneklenmiş dosyaları (öntanımlı tümü) ithal et
sourcedir() {
	local directory="$1"
	if [ $# -gt 1 ]; then
		shift
	else
		set -- ""
	fi

	local prefix f
	for prefix in "${@:-}"; do
		for f in "${directory}/"${prefix}*; do
			case "${f}" in "${directory}/${prefix}"'*') break ;; esac
			for f in "${directory}/"${prefix}*; do
				. "${f}"
			done
			break
		done
	done
}

# verilen dizinde öneklenmiş dosyaları (öntanımlı tümü) listele
listdir() {
	local directory="$1"
	if [ $# -gt 1 ]; then
		shift
	else
		set -- ""
	fi

	local prefix f
	for prefix in "${@:-}"; do
		for f in "${directory}/"${prefix}*; do
			case "${f}" in "${directory}/${prefix}"'*') break ;; esac
			for f in "${directory}/"${prefix}*; do
				echo "$f"
			done
			break
		done
	done
}

# komut PATH içinde var mı?
hascommand() {
	local oldifs="$IFS"; IFS=':'

	local p
	for p in $PATH; do
		if [ -x "${p}/${*}" ] && [ -f "${p}/${*}" ]; then
			IFS="$oldifs"
			return 0
		fi
	done

	IFS="$oldifs"

	return 1
}

# PATH türünde değişkenlere ekleme yap
mungedpath() {
	local path p where

	path="$1"; p="$2"; where="$3"

	case "$path" in
	*:$p:*|$p:*|*:$p|$p)
		echo "${path}"
		;;
	*)
		case "$where" in
		after)
			echo "${path}${path:+:}${p}"
			;;
		*)
			echo "${p}${path:+:}${path}"
			;;
		esac
		;;
	esac
}

# RedHat'in ilgili işlevi
pathmunge() {
	PATH=$(mungedpath "$PATH" "$@")
}

# tercih edilen sırada bir program seç
selectalternatives() {
	local prog
	prog=$(echo "$(eval echo \$$1)")

	if [ -n "$prog" ]; then
		case "$prog" in
		/*)
			[ -x "$prog" ] || prog=
			;;
		*)
			hascommand $prog || prog=
			;;
		esac
	elif [ $# -gt 1 ]; then
		local p
		shift
		for p; do
			case "$p" in
			/*)
				if [ -x "$p" ]; then
					prog=$p
					break
				fi
				;;
			esac
			if hascommand $p; then
				prog=$p
				break
			fi
		done
	fi

	echo "$prog"
}

# güvenli şekilde yönlendirme yapılabilecek bir dosya oluştur
touchsafe() {
	local file perm

	file="$1"
	perm="$2"

	[ -n "$perm" ] || perm=600

	if (umask 077 && touch "$file") 2>/dev/null && [ -w "$file" ] && [ ! -L "$file" ]; then
		chmod "$perm" "$file"
	else
		echo >&2 "'$file' dosyası güvenli değil"
		exit 1
	fi
}

# ilk argüman diğer argümanlarda geçiyor mu?
has() {
	local first
	first="$1"

	[ $# -gt 1 ] || return 1
	shift

	case " $* " in *" $first "*) return 0 ;; esac
	return 1
}

# verilen niteliklerin herhangi biri var mı?
anyattr() {
	local attr

	for attr; do
		has "$attr" $X_ATTR && return 0
	done

	return 1
}

# verilen niteliklerin tümü var mı?
allattr() {
	local attr

	for attr; do
		has "$attr" $X_ATTR || return 1
	done

	return 0
}

# verilen nitelikleri ekle
setattr() {
	local attr

	for attr; do
		X_ATTR="$X_ATTR $attr"
	done
}

# git ortam değişkenlerini (gerekiyorsa) ilkleyerek ithal et
exportgit() {
	local name email user token

	if [ -z "$GIT_AUTHOR_NAME" ]; then
		name="$(git config --global --get user.name 2>/dev/null ||:)"
		[ -n "$name" ] || name="$X_NAME"
		[ -z "$name" ] || export GIT_AUTHOR_NAME="$name"
	fi
	if [ -z "$GIT_AUTHOR_EMAIL" ]; then
		email="$(git config --global --get user.email 2>/dev/null ||:)"
		[ -n "$email" ] || email="$X_EMAIL"
		[ -z "$email" ] || export GIT_AUTHOR_EMAIL="$email"
	fi
	if [ -z "$GIT_COMMITTER_NAME" ] && [ -n "$GIT_AUTHOR_NAME" ]; then
		export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
	fi
	if [ -z "$GIT_COMMITTER_EMAIL" ] && [ -n "$GIT_AUTHOR_EMAIL" ]; then
		export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
	fi
	if [ -z "$GITHUB_USER" ]; then
		user="$(git  config --global --get github.user  2>/dev/null ||:)"
		[ -n "$user" ] || user=${GIT_AUTHOR_EMAIL%%@*}
		[ -z "$user" ] || export GITHUB_USER="$user"
	fi
	if [ -z "$GITHUB_TOKEN" ]; then
		token="$(git config --global --get github.token 2>/dev/null ||:)"
		if [ -z "$token" ] && [ -r "$HOME/.private/github" ]; then
			token=$(cat "$HOME/.private/github" ||:)
		fi
		[ -z "$token" ] || export GITHUB_TOKEN="$token"
	fi
}

# x ortam değişkenlerini anons et
exportx() {
	# üzerine yazılan bir değişken olduğundan PATH'i her seferinde ayarla
	PATH="$X_PATH"

	export PATH X_PATH X_ATTR X_EDITOR X_TERM X_SCREEN X_NAME X_EMAIL
}

# bulunulan ortamdaki (neredeyse) tüm işlevleri ihraç et
exportmostf() {
	# Bash gerekli
	[ -n "$BASH" ] || return 0
	export -f $(
		declare -F | while read _ _ name; do
			expr "$name" : '\(_*\|main\|*_\)' >/dev/null || echo "$name"
		done
	)
}
