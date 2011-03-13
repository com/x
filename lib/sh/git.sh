# hangi daldayız?
git_current_branch() {
	local br

	br=$(git symbolic-ref -q HEAD)
	br=${br##refs/heads/}
	br=${br:-HEAD}

	echo "$br"
}

# dal mevcut mu?
git_branch_exist() {
	git show-ref -q "$1"
}

# depo temiz durumda mı?
git_modified() {
	[ -n "$(git ls-files -m "$@" 2>/dev/null ||:)" ]
}

# geçici olarak tüm değişiklikleri kaydet
git_stash_push() {
	unset GIT_STASH_PUSHED
	if git_modified; then
		GIT_STASH_PUSHED=yes
		git stash save -q
	fi
}

# değişiklikleri geri yükle
git_stash_pop() {
	if [ -n "$GIT_STASH_PUSHED" ]; then
		git stash pop -q
	fi
}

# verilen dala geçerek bir şey yap ve geri dön
git_on_branch() {
	local br callback cur

	br="$1"
	callback="$2"
	shift 2

	if git_branch_exist "$br"; then
		cur=$(git_current_branch)
		git_stash_push
		git checkout "$br"
		$callback "$@"
		git checkout "$cur"
		git_stash_pop
	else
		echo >&2 "$br dalı yok veya sorunlu"
		return 1
	fi
}

# verilen dizin bir git çalışma kopyası mı?
git_iswc() {
	case "$(
		LC_ALL=C GIT_DIR="$1/.git" /usr/bin/git rev-parse --is-inside-work-tree 2>/dev/null ||:
	)" in
	true)  return 0 ;;
	false) return 1 ;;
	*)     return 2 ;;
	esac
}

# GitHub API

# github api erişimi
gh_api() {
	local args user token url https quiet format command

	unset REPLY

	args=$(getopt "su:t:f:" $*) || bug "getopt hatası: $*"

	set -- $args
	while [ $# -ge 0 ]; do
		case "$1" in
		-s) https=yes;   shift ;;
		-u) user="$2";   shift; shift ;;
		-t) token="$2";	 shift; shift ;;
		-f) format="$2"; shift; shift ;;
		--) shift; break ;;
		esac
	done

	[ $# -eq 1 ] || bug "eksik veya fazla argüman"

	: ${user:="$GITHUB_USER"}
	: ${token:="$GITHUB_TOKEN"}
	: ${format:='yaml'}

	url=$(printf "$1" "$user")

	if [ -n "$https" ]; then
		[ -n "$user"  ] || bug "GitHub hesabı verilmeli"
		[ -n "$token" ] || bug "GitHub token verilmeli"
		command="curl -s -F 'login=${user}' -F 'token=${token}' https://github.com/api/v2/${format}/${url}"
	else
		command="curl -s http://github.com/api/v2/${format}/${url}"
	fi

	REPLY=$($command 2>/dev/null)     || return
	if echo "$REPLY" | egrep -q '^error'; then
		REPLY=
		return 1
	fi
}

# verilen dizgi geçerli bir github token değeri mi?
gh_istoken() {
	local token="$1"
	[ ${#token} -eq 32 ] || return 1
	echo "$token" | egrep -q -v '[0-9a-fA-F]' && return 1
	return 0
}

# github api için http ve https erişimleri
gh_http()  { gh_api    "$@"; }
gh_https() { gh_api -s "$@"; }

# github ssh ile erişilebilir durumda mı?
gh_writable() {
	# SSH kontrolünü sadece bir kere yapmak için sonucu sakla
	if [ -z "${IS_SSHABLE+X}" ]; then
		# SSH agent aktif değilse basitçe gerek şartları kontrol edeceğiz.
		if [ -z "$(ssh-add -l 2>/dev/null ||:)" ]; then
			# ~/.ssh dizini yok veya boşsa SSH kullanılamaz.
			if ! [ -d ~/.ssh ] || [ -r ~/.ssh/id_rsa ] || [ -r ~/.ssh/id_dsa ]; then
				IS_SSHABLE=no
			fi
		fi
		if [ -z "${IS_SSHABLE+X}" ]; then
			# Aksi halde daha yorucu ve çirkin bir kontrol gerekiyor.
			cry "SSH erişimi kontrol ediliyor (SSH parolası istenebilir)..."
			if ssh -T -o StrictHostKeyChecking=no git@github.com 2>&1 |
				egrep -q 'successfully authenticated'; then
				IS_SSHABLE=yes
			else
				IS_SSHABLE=no
			fi
		fi
	fi

	case "$IS_SSHABLE" in yes) return 0 ;; no) return 1 ;; esac
}
