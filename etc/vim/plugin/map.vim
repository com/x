" Make p in Visual mode replace the selected text with the "" register
vnoremap p <esc>:let current_reg = @"<cr>gv"_di<c-r>=current_reg<cr><esc>

" <del> always deletes without a side effect
noremap <del> "_x

" Don't use Ex mode, use Q for formatting
noremap Q gq

" Y yanks to the end of line
noremap Y y$

" Command line typos
cabbrev W w
cabbrev Wq wq
cabbrev E e
cabbrev Sp sp
cabbrev Q q

" Toggle 'paste' mode
" This also inhibit auto format of 'fo=a' option.
set pastetoggle=<f2>

" This should be standart
imap <c-bs> <c-w>

" Bring the current line to command line
cmap <c-x>rl <c-r>=getline(".")<cr>
cmap <c-x>l <c-r>=getline(".")<cr>

" Format text
vnoremap <c-x>a gqgv=
nnoremap <c-x>a gqap
imap <c-x>a <esc>mt<c-x>a`ta

" Open some special files
nnoremap <c-x>or :sp ~/.vimrc<cr>
vmap <c-x>or <c-c><c-x>or
imap <c-x>or <c-o><c-x>or

" Save
nnoremap <c-x>s :update<cr>
vmap <c-x>s <c-c><c-x>s
imap <c-x>s <c-o><c-x>s

" Move window to the bottom
nnoremap <c-x>j <c-w>j<c-w>_
vnoremap <c-x>j <c-c><c-w>j<c-w>_
inoremap <c-x>j <c-o><c-w>j<c-o><c-w>_

" Move window to the top
nnoremap <c-x>k <c-w>k<c-w>_
vnoremap <c-x>k <c-c><c-w>k<c-w>_
inoremap <c-x>k <c-o><c-w>k<c-o><c-w>_

" Navigate
nnoremap <c-x>w <c-w>w<c-w>_
vnoremap <c-x>w <c-c><c-w>w<c-w>_
inoremap <c-x>w <c-o><c-w>w<c-o><c-w>_
cnoremap <c-x>w <c-c><c-w>w<c-w>_:<c-p>

" Navigate (default behaviour)
nnoremap <c-x>W <c-w>w
vmap <c-x>W <c-c><c-w>w
imap <c-x>W <c-o><c-w>w

" Maximize window
nnoremap <silent> <c-x>z :only<cr>
vmap <silent> <c-x>z <c-c><c-x>z
imap <silent> <c-x>z <c-o><c-x>z

" Quit
nnoremap <silent> <c-x>q :q<cr>
vmap <silent> <c-x>q <c-c><c-x>q
imap <silent> <c-x>q <c-o><c-x>q

" Abort all
nnoremap <silent> <c-x>Q :qa!<cr>
vmap <silent> <c-x>Q <c-c><c-x>Q
imap <silent> <c-x>Q <c-o><c-x>Q

" Split
nnoremap <c-x>f :sp<space>
vmap <c-x>f <c-c><c-x>f
imap <c-x>f <c-o><c-x>f

" Edit
nnoremap <c-x>F :e<space>
vmap <c-x>F <c-c><c-x>F
imap <c-x>F <c-o><c-x>F

" Help
nnoremap <c-x>h :h<space>
vmap <c-x>h <c-c><c-x>h
imap <c-x>h <c-o><c-x>h

" No highlightsearch
map <silent> <leader><cr> :noh<cr>

" Hilight search
nnoremap <c-x>th :set hls!<cr>
vmap <c-x>th <c-c><c-x>th
imap <c-x>th <c-o><c-x>th

" Show spaces etc
nnoremap <c-x>tl :set list!<cr>
vmap <c-x>tl <c-c><c-x>tl
imap <c-x>tl <c-o><c-x>tl

nnoremap <c-x>tp :TogglePatchMode<cr>
vmap <c-x>tp <c-c><c-x>tp
imap <c-x>tp <c-o><c-x>tp

" Next error
nnoremap <silent> <c-x>j :cn<cr>
vmap <silent> <c-x>j <c-c><c-x>j
imap <silent> <c-x>j <c-o><c-x>j

" Previous error
nnoremap <silent> <c-x>k :cp<cr>
vmap <silent> <c-x>k <c-c><c-x>k
imap <silent> <c-x>k <c-o><c-x>k

" Used to track the quickfix window
augroup quickfixedit
	autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
	autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
	autocmd QuickFixCmdPost * cwindow | redraw! | let g:qfix_win = bufnr("$")
augroup END

map <silent> <f6> <esc>:QuickFixToggle<cr>

map <leader>! :SheBang<cr>

" Meta tuşları
function! s:mapa(letters, leader)
	" XXX Needed for Meta keys.
	set winaltkeys=no

	for c in a:letters
		execute   'map <silent> <m-' . c . '> ' . a:leader . c . '|' .
				\ 'imap <silent> <m-' . c . '> ' . a:leader . c
	endfor
	if $DISPLAY != "" || $SSH_CLIENT != "" | return | endif
	" Kludge to use Alt key (as Meta) in linux console.
	" Watch for the side-effects.
	for c in a:letters
		silent! execute 'set <m-' . c . '>=' . c
	endfor
endfun

" Omitting g/G p/P and v /V, these are conflicting with some Turkish chars.
call s:mapa([
	\ '0','1','2','3','4','5','6','7','8','9',
	\ 'a','b','c','d','e','f',    'h','i','j',
	\ 'k','l','m','n','o',    'q','r','s','t',
	\ 'u',    'w','x','y','z',
	\ '<', '/', '-', '*', '.', ',', '"', '',
	\ ], '<c-x>')
