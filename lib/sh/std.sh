# renkli ileti ortamını sıfırla
unsetcolors() {
	COLS=80

	CO_GOOD=
	CO_WARN=
	CO_BAD=
	CO_NORMAL=
	CO_HILITE=
	CO_BRACKET=
	CO_XBLUE=
	CO_XGREEN=
	CO_XPINK=
	CO_XGREY=
}

# renkli iletileri ve uçbirim genişliğini hazırla
setcolors() {
	COLS=${COLUMNS:-0}

	[ $COLS -eq 0 ] && COLS=$(
		set -- $(stty size </dev/tty 2>/dev/null); echo ${2:-0}
	) ||:
	[ $COLS -gt 0 ] || COLS=80

	CO_GOOD='\033[32;01m'
	CO_WARN='\033[33;01m'
	CO_BAD='\033[31;01m'
	CO_HILITE='\033[36;01m'
	CO_BRACKET='\033[34;01m'
	CO_NORMAL='\033[0m'
	CO_XBLUE='\033[38;5;111m'
	CO_XGREEN='\033[38;5;120m'
	CO_XPINK='\033[38;5;198m'
	CO_XGREY='\033[38;5;250m'
}

# alt kabuklara renkleri ihraç et
exportcolors() {
	export COLS

	export \
	CO_GOOD \
	CO_WARN \
	CO_BAD \
	CO_HILITE \
	CO_BRACKET \
	CO_NORMAL \
	CO_XBLUE \
	CO_XGREEN \
	CO_XPINK \
	CO_XGREY
}

# 8 bit ANSI renk kodunu üret
color256() { echo -ne "\[\033[38;5;$1m\]"; }

# iletiyi stderr'de görüntüle
message() {
	printf -- "$*\n" | fold -s -w ${COLS:-80} >&2
}

# iletiyi satır sonu olmadan stderr'de görüntüle
messagen() {
	printf -- "$*" | fold -s -w ${COLS:-80} >&2
}

# uyarı iletisi
cry() {
	message_ "${CO_WARN}${*}${CO_NORMAL}"
}

# hata iletisi
die() {
	message_ "${CO_BAD}${*}${CO_NORMAL}"
	exit 19
}

initcolors() {
	# renkli iletiler kullanılsın mı?
	case "${NOCOLOR:-false}" in
	yes|true)
		unsetcolors
		;;
	no|false)
		setcolors
		exportcolors
		;;
	esac
}

# öngörülemeyen yazılım hatası iletisi
bug() {
	message_ "$@"
	cry "Bu bir yazılım hatası, lütfen raporlayın."
	exit 70
}

# renkli bir ileti
say() {
	message_ "${CO_GOOD}${*}${CO_NORMAL}"
}

# eksik deb paketleri
missingdeb() {
	local pkg missing
	for pkg; do
		if [ -z "$(dpkg-query -W -f='${Installed-Size}' "$pkg" 2>/dev/null ||:)" ]; then
			missing="$missing $pkg"
		fi
	done

	echo $missing
}

# deb paket(ler)i kurulu mu?
hasdeb() {
	[ -z "$(missingdeb $*)" ]
}

# eksik ruby gem paketleri
missinggem() {
	hascommand gem || bug "ruby gem kurulu değil"

	local pkg missing=
	for pkg; do
		if ! gem query -i -n '^'"$pkg"'$' >/dev/null 2>&1; then
			missing="$missing $pkg"
		fi
	done

	echo $missing
}

# ruby gem paket(ler)i kurulu mu?
hasgem() {
	[ -z "$(missinggem $*)" ]
}

# kurulu deb paketi verilen sürümden daha mı eski
hasolddeb() {
	local pkg version

	[ $# -gt 0 ] || return 0

	pkg="$1"; version="$2"

	set -- $(dpkg-query -W "$pkg" 2>/dev/null ||:)
	if [ -z "$2" ]; then
		# paket kurulu değilse "true", yani olmayan paket eski bir paket
		return 0
	elif [ -z "$version" ]; then
		# sürüm verilmemiş ama paket varsa "false", yani sürüm önemsiz
		return 1
	fi

	# aksi halde karşılaştır
	dpkg --compare-versions "$2" lt "$version"
}

# verilen deb paketlerinin kurulu olduğuna emin ol
ensuredeb() {
	local missing=$(missingdeb "$@")
	[ -z "$missing" ] || die "Devam etmeniz için şu paketlerin kurulması gerekiyor: " $missing
}

# verilen ruby gem paketlerinin kurulu olduğuna emin ol
ensuregem() {
	local missing=$(missinggem "$@")
	[ -z "$missing" ] || die "Devam etmeniz için şu gem paketlerinin kurulması gerekiyor: " $missing
}

# kullanıcı ayrıcalıklı mı?
isprivileged() {
	local g

	if [ $(id -u) -eq 0 ]; then
		return 0
	else
		for g in $(groups); do
			case "$g" in
			sudo|admin|wheel|staff)
				return 0 ;;
			esac
		done
	fi

	return 1
}

# sudo gerektiren işlemlerin öncesinde sudo parolası zaman aşımını tazele
sudostart() {
	if [ $(id -u) -ne 0 ]; then
		cry "Yönetici hakları gerekecek; sudo parolası sorulabilir."
		local prompt=${*:-'Lütfen "%u" için parola girin: '}
		if ! sudo -v -p "$prompt"; then
			die "Parolayı hatalı giriyorsunuz veya yönetici olma yetkiniz yok!"
		fi
	fi
}

# sudo gerektiren bir işleme teşebbüs
sudoattempt() {
	if [ $(id -u) -ne 0 ]; then
		if ! isprivileged; then
			cry "Yönetici yetkisinde olan bir işlem yapmak üzeresiniz. " \
			    "Fakat görüldüğü kadarıyla bu sistemde yöneticilerin dahil" \
				"olduğu bir grupta değilsiniz."
			if yesno "Buna rağmen yönetim yetkileri istemekte" \
			         "kararlı mısınız?" h; then
				die "Lütfen düşündüğünüz işlem için sistem yöneticilerine " \
				    "başvurun.  İşleme son verildi."
			fi
		fi
		sudostart
	fi
}

# güvenli geçici dizin oluştur
usetempdir() {
	local tempname="$1" keeptemp="$2"

	local prefix="$PROGNAME"
	[ -n "$prefix" ] || prefix=${0##*/}

	# As a security measure refuse to proceed if mktemp is not available.
	[ -x /bin/mktemp ] || die "'/bin/mktemp' bulunamadı; sonlanıyor."

	local tempdir="$(/bin/mktemp -d -t ${prefix}.XXXXXXXX)" ||
		die "mktemp hata döndü"

	[ -d "$tempdir" ] || die "geçici bir dizin oluşturulamadı"

	eval $(echo "$tempname=\"$tempdir\"")

	if [ -z "$keeptemp" ]; then
		trap '
			exitcode=$?
			if [ -d "'$tempdir'" ]; then
				rm -rf -- "'$tempdir'"
			fi
			exit $exitcode
		' EXIT HUP INT QUIT TERM
	fi
}

# git deposunu denetle ve tepe dizine çık
ensuretopgitdir() {
	local up
	if ! up="$(git rev-parse --show-cdup 2>/dev/null)"; then
		die "Çalışma dizini bir git deposu değil"
	fi
	[ -z "$up" ] || cd "$up"
}

# ayrıntılı ileti
if [ -n "$VERBOSE" ]; then
	verbose() { message_ "$@"; }
else
	verbose() { :; }
fi

# iletilerde ileti kaynağı isteniyorsa ekle
if [ -n "$ERROR_MESSAGE_DOMAIN" ]; then
	message_ () {
		message "${ERROR_MESSAGE_DOMAIN}: $*"
	}
else
	message_ () {
		message "$*"
	}
fi

initcolors

# check if console is interactive
isinteractive() {
	tty -s 2>/dev/null
}

# öntanımlı değeri bekleterek kullanıcıdan girdi iste
ask() {
	local prompt="$1"

	unset REPLY
	if [ $# -gt 1 ]; then
		local default="$2"
		printf "${CO_HILITE}${prompt} ${CO_NORMAL}[${CO_BRACKET}$default${CO_NORMAL}]? "
		read -e REPLY </dev/tty
		[ -n "$REPLY" ] || REPLY="$default"
	else
		printf "${CO_HILITE}${prompt}${CO_NORMAL}? "
		read -e REPLY </dev/tty
	fi

	# answer is in REPLY
}

# güvenli şekilde parola sor
asksecret() {
	local prompt="$1"

	unset REPLY
	printf "${CO_HILITE}${prompt}${CO_NORMAL}? "
	stty -echo </dev/tty
	read -e REPLY </dev/tty
	stty echo </dev/tty
	printf "\n"

	# answer is in REPLY
}

# öntanımlı cevabı bekleterek kullanıcıya evet/hayır sor
yesno() {
	local default prompt answer

	default=${2:-'e'}

	case "$default" in
	[eEyY]*) prompt="[${CO_BRACKET}E/h${CO_NORMAL}]" ;;
	[hHnN]*) prompt="[${CO_BRACKET}e/H${CO_NORMAL}]" ;;
	esac

	while :; do
		printf "${CO_HILITE}$1 $prompt ${CO_NORMAL}"
		read -e answer </dev/tty

		case "${answer:-$default}" in
		[eE] | [eE][vV] | [eE][vV][eE] | [eE][vV][eE][tT] | \
		[yY] | [yY][eE] | [yY][eE][sS])
			return 0
			;;
		[hH] | [hH][aA] | [hH][aA][yY] | [hH][aA][yY][ıI] | [hH][aA][yY][ıI][rR] | \
		[nN] | [nN][oO])
			return 1
			;;
		*)
			printf "${CO_BAD}Lütfen '[e]vet' veya '[h]ayır' girin${CO_NORMAL}\n"
			;;
		esac
	done
}
