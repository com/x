# verilen dizgilerin ilk harflerini büyüt
titlecase() {
	local s
	for s; do
		s="${s,,}"
		case "$s" in
		i*) s="İ${s:1:${#s}}" ;;
		ı*) s="I${s:1:${#s}}" ;;
		ğ*) s="Ğ${s:1:${#s}}" ;;
		ü*) s="Ü${s:1:${#s}}" ;;
		ş*) s="Ş${s:1:${#s}}" ;;
		ö*) s="Ö${s:1:${#s}}" ;;
		ç*) s="Ç${s:1:${#s}}" ;;
		*)  s=${s^}           ;;
		esac
		echo -n $s
		echo -n " "
	done
}
