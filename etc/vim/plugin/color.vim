" Renk desteği zayıf bir terminalde miyiz?
if ' ' . $X_ATTR . ' ' =~ ' dumb ' || &term == 'linux'
	set t_Co=16 background=dark
	silent! colorscheme murphy
else
	" 256 rengi etkinleştir.
	set t_Co=256
	if has('gui_running')
		silent! colorscheme github
		if has('unix')
			" Grafik ortamda tercih ettiğimiz yazıtipi.
			set guifont=Terminus\ Bold\ 14
		endif
	else
		set background=dark
		" Diğer bir alternatif 'desert256'.  Renk teması (colorscheme)
		" etc/vim/after/plugin/local.vim dosyasında değiştirilebilir.
		silent! colorscheme tir_black
	endif
endif

" Kolay seçilebilirlik için bazı renkleri özel ayarla.
highlight PmenuSel cterm=bold,reverse ctermfg=cyan
highlight MatchParen ctermfg=red ctermbg=black
