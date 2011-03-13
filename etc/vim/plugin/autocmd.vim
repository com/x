augroup csharpedit
	if has('unix')
		autocmd FileType cs silent compiler gmcs
	endif
augroup END

augroup mailedit
	" Use <d--> to delete from the current line to signature.
	autocmd FileType mail onoremap -- /\n^-- \=$\\|\%$/-1<cr>
	autocmd FileType mail setlocal tw=72 et fo=tcrq2nw

	" Check missing attachments in mutt.  Stolen from Hugo Haas <hugo@larve.net>.
	function! CheckAttachments()
		let l:english = 'attach\(ing\|ed\|ment\)\?'
		" TODO Add Turkish.
		let l:turkish = 'ek\([dt]e\|inde\)'
		let l:ic = &ignorecase
		if (l:ic == 0)
			set ignorecase
		endif
		if (search('^\([^>|].*\)\?\<\(re-\?\)\?\(' .
		\ l:english . '\|' . l:turkish . '\)\>', 'w') != 0)
			echohl Special
			call input('Sanırım bu iletiye bir dosya eklemeniz gerekiyor...  [Devam etmek için ENTER] ')
			echohl None
		endif
		if (l:ic == 0)
			set noignorecase
		endif
		echo
	endfunction
	autocmd BufUnload mutt-* call CheckAttachments()
augroup END

augroup markdownedit
	autocmd FileType markdown setlocal et nosta sts=4 sw=4
augroup END

augroup otledit
	autocmd FileType vo_base setlocal foldcolumn=0
	autocmd BufRead,BufNewFile *.vala set ft=vala
augroup END

augroup podedit
	" when editing a .pod file, you can :make it; and then the command
	" :cope will open a nice little window with all pod errors and
	" warnings, correctly recognized, so you can jump on the corresponding
	" lines in the pod source file only by selecting them.
	" 	-- Trick from Rafael Garcia Suarez
	autocmd FileType pod
		\ setlocal makeprg=podchecker\ -warnings\ %\ 2>&1\\\|sed\ 's,at.line,:&,'
	autocmd FileType pod
		\ setlocal errorformat=%m:at\ line\ %l\ in\ file\ %f
augroup END

augroup quickfix
	" Use space key to walk around quickfix list.
	autocmd FileType qf nnoremap <buffer> <space> <cr>:set cursorline\|wincmd p<cr>
augroup END

augroup pythonedit
	autocmd FileType python setlocal ts=4 sts=4 sw=4 tw=80 et si ai
augroup END

augroup rubyedit
	autocmd FileType ruby,eruby,yaml setlocal ai et sw=2 sts=2
augroup END

augroup shelledit
	autocmd FileType sh setlocal ai sts=8 sw=8 noet
augroup END

augroup sgmledit
	" Sgml documentation style for FreeBSD.
	autocmd FileType html,sgml,xml setlocal sw=2 sts=2 fo=tcq2wa
augroup END

augroup texedit
	autocmd FileType tex setlocal sw=2 iskeyword+=: fo=tcq2n
augroup END

augroup valaedit
	autocmd FileType vala setlocal errorformat=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
augroup END

augroup vimedit
	autocmd FileType vim setlocal fo=tcq2n tw=0
augroup END

augroup ronnedit
	function! RonnUpdate()
		if &modified
			echohl Special
			call input('Kaynak değişti, kılavuz güncellenecek...  [Devam etmek için ENTER]')
			execute "!rake"
			call input('Güncelleme yapıldı.')
			echohl None
		endif
	endfunction

	autocmd BufRead,BufNewFile *.ronn setlocal makeprg=rake
	autocmd BufWrite *not.*.ronn call RonnUpdate()
augroup END
