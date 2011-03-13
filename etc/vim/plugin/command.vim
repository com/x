if exists("g:loaded_x") || &cpoptions
	finish
endif
let g:loaded_x = 1

" Toggle fold state between closed and opened.
" If there is no fold at current line, just moves forward.
" If it is present, reverse it's state.
function! s:togglefold()
	if foldlevel(".") == 0
		normal! l
	else
		if foldclosed(".") < 0
			. foldclose
		else
			. foldopen
		endif
	endif
	" Clear status line
	echo
endfunction
command! -nargs=0 ToggleFold call s:togglefold()

" Dumb function for reformatting.
function! s:reformat_paragraph()
	let lnum = line(".")
	let cnum = virtcol(".")
	set ww+=h,l

	execute '?\(<p>\|<para>\|<example>\|<item>\|<tag>\)' execute 'normal f>lmA'
	execute '/\(^[
	]*$\|<\/p>\|<\/para>\|<\/example>\|<\/item>\|<\/tag>\)' execute 'normal
	hmB' execute 'normal! `Av`Bgq'

	set ww-=h,l
	execute 'normal '. lnum .'G'
	execute 'normal '. cnum .'|'
endfunction
command! -nargs=0 ReformatParagraph call s:reformat_paragraph()

" Text indent from list bullets.
let s:bullet_pattern =
\ '^\s*\(\(\[\|(\)[a-zA-Z0-9]\{1,3}\(\]\|)\)\|[*+-]\+\|[a-zA-Z0-9]\{1,3}\(\.)*\|\.*)\)\)\s\+'
function! s:get_text_indent()
	if v:lnum == 1
		return 0
	endif

	let indent = indent(v:lnum - 1)
	let line = getline(v:lnum - 1)

	if line =~ s:bullet_pattern
		let indent = matchend(line, s:bullet_pattern)
	endif

	return indent
endfunction
command! -nargs=0 GetTextIndent call s:get_text_indent()

" Highlight long lines.
function! s:long_line(...)
	let linewidth = (a:0 > 0) ? a:1 : &tw

	if linewidth == 0 && a:0 == 0
		let linewidth = 80
	endif

	" Do not include the line end.
	let linewidth = linewidth + 1

	let group = 'LongLine'

	silent! execute 'highlight clear ' . group

	if &bg == 'dark'
		execute 'highlight ' . group .
			\ ' ctermfg=yellow ctermbg=red guifg=yellow guibg=red'
	else
		execute 'highlight ' . group .
			\ ' ctermbg=yellow ctermfg=red guibg=yellow guifg=red'
	endif

	let pattern = '/.\%>' . linewidth . 'v/'
	execute 'match ' . group . ' ' . pattern
	execute 'vimgrep ' . pattern . ' %'
endfunction
command! -nargs=* LL call s:long_line(<args>)

" Remove trailing spaces.
command! -nargs=0 WS %s/\s\+$//gce

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" Create manual foldmarkers in brace blocks.
function! CreateFoldMarker(toggle)
	" We want a leading space before fold markers.
	let s:cms_save = &cms
	execute "set cms=" . "\\ " . &cms
	if a:toggle
		normal zfa{
	else
		normal zd
	endif
	execute "set cms=" . s:cms_save
endfunction

function! FoldSetup()
	if &l:foldmethod | return | endif

	setl foldnestmax=1
	if &ft == 'vim'
		" Too slow
		setl foldmethod=indent
	elseif &ft == 'perl'
		let perl_fold = 1
	elseif &ft == 'sh'
		setl foldmethod=indent
	elseif &ft != 'markdown'
		setl foldmethod=syntax
	elseif
		" Too slow
		"setl foldmethod=syntax
		setl foldmethod=indent
	endif
endfunction

" Toggles the quickfix window.  VIM tip: 1008
function! s:togglequickfix(forced)
	if exists("g:qfix_win") && a:forced == 0
		cclose
	else
		copen
	endif
endfunction
command! -bang -nargs=? QuickFixToggle call s:togglequickfix(<bang>0)

" SheBang
function! s:she_bang()
	if &ft == ""
		return
	endif

	let executable = findfile(&ft, '/bin,/sbin,/usr/bin,/usr/sbin')

	if executable == ""
		return
	endif

	if &ft == 'perl'
		let header = "use strict;use warnings;"
	else
		let header = ""
	endif

	normal mz1G
	if match(getline("."), "^#\\s*!") == -1
		set autoread
		execute "normal O#!" . executable . "" . header
		write
		call system("chmod +x " . expand("%"))
	endif
	normal `z
endfunction
command! -nargs=0 SheBang call s:she_bang()

" Patch mode.
function! s:toggle_patch_mode()
	if &pm == ''
		set pm=.orig
		let msg='Patch mode enabled!'
	else
		set pm=
		let msg='No patch!'
	endif
	call s:warn_and_pause(msg . '  Any key to continue...')
endfunction
command! -nargs=0 TogglePatchMode call s:toggle_patch_mode()
