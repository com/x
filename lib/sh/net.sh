# ağ bağlantısı var mı?
hasnetwork() {
	local try
	# ağ bağlantısı?  google dns cevap vermiyorsa 3. dünya savaşı
	# TODO gelecekte bu denetimi upstart veya startd ile yapmak lazım
	for try in 1 2 3 4 5; do
		/usr/bin/netcat -z -w 5 8.8.8.8 53 && return 0
	done
	return 1
}
