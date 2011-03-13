" Eklenti tercihleri

" Bazı eklentiler kullanıcı tercihlerini yüklenmeden sonra alıyor.  Bu tür
" eklentilerin kullanıcı tercihlerini bu dosyada tutuyoruz.  DİKKAT!  Önce
" eklentinin varlığını denetlemelisiniz.  Aksi halde hata olacaktır.

if exists("g:loaded_syntastic_plugin")
	SyntasticEnable
	set statusline+=%#warningmsg#
	set statusline+=%{SyntasticStatuslineFlag()}
	set statusline+=%*
endif

if exists("g:loaded_SingleCompile")
	if ! hasmapto("<F9>")
		nmap <F9>   :SCCompile<cr>
	endif
	if ! hasmapto("<F10>")
		nmap <F10> :SCCompileRun<cr>
	endif
endif

if exists("g:loaded_yaifa")
	function! s:unload_yaifa_on_blank_files()
		let i = 1
		while i <= 10
			if getline(i) =~ '\S'
				return
			endif
			let i += 1
		endwhile
		au! YAIFA
	endfunction
	au FileType * call s:unload_yaifa_on_blank_files()
endif
