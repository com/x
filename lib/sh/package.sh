# apt-get sarmalayıcı
xaptget() {
	local command
	[ $# -gt 0 ] || return 0

	command="$1"
	shift

	sudo apt-get $command --option APT::Get::HideAutoRemove=1 \
		--quiet --yes --force-yes --no-install-recommends --ignore-missing "$@"
}

# aptitude sarmalayıcı
xaptitude() {
	# Paket kurulumu için bunu tercih ediyoruz çünkü aptitude eksik paketleri
	# atlayarak kurulum yapabiliyor, bk. http://bugs.debian.org/503215
	# Dikkat!  Ubuntu'da aptitude standart olarak kurulu gelmiyor.
	local command
	[ $# -gt 0 ] || return 0

	command="$1"
	shift

	sudo aptitude $command -f --quiet --assume-yes --without-recommends --safe-resolver "$@"
}

# adresi verilen bir deb paketini indir ve kur
debinstall() {
	local url deb

	url="$1"

	deb=$(mktemp) || die "Geçici dosya oluşturulamadı"
	if wget "$url" -O"$deb" 2>/dev/null; then
		if [ ! -f "$deb" ]; then
			echo >&2 "$url adresinden bir dosya indirilemedi."
			return 1
		fi
		if [ -n "$(which file 2>/dev/null ||:)" ]; then
			case "$(file --mime-type $deb 2>/dev/null ||:)" in
			*:\ application/octet-stream)
				;;
			*)
				echo >&2 "$url adresinden indirilen dosya bir ikili paket değil."
				return 1
				;;
			esac
		fi

		sudo dpkg -i "$deb" && return 0

		echo >&2 "$url kurulurken hatayla karşılaşıldı; düzeltilecek."
		sudo apt-get -f install ||:
	fi

	return 1
}

# wajig sarmalayıcı
xwajig() {
	local command
	[ $# -gt 1 ] || return 0

	command="$1"
	shift

	wajig -n -q -y $command "$@"
}

# gem sarmalayıcı (öntanımlı)
xgem() {
	local command
	[ $# -gt 1 ] || return 0

	command="$1"
	shift

	sudo gem $command --quiet --force --no-ri --no-rdoc "$@"
}

# gem sarmalayıcı (1.9 serisi ile)
xgem191() {
	local command
	[ $# -gt 1 ] || return 0

	command="$1"
	shift

	sudo gem1.9.1 $command --quiet --force --no-ri --no-rdoc "$@"
}
