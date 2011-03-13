# verilen isimdeki değişkene yaz
setv() {
	local name="$1" value="$2"
	eval $(echo "$name=\"$value\"")
}

# verilen isimdeki değişkeni oku
getv() {
	local name="$1"
	echo "$(eval echo \$$name)"
}
