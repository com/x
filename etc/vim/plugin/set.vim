set autoindent
set autowrite
set backspace=indent,eol,start
set backupdir=./.backup,~/.backup,.,/tmp
set backupskip=
set cpoptions+=J
set cpoptions-=<
set fileformats=unix,dos,mac
set foldlevel=0
set foldmethod=marker
set formatoptions=tq2n
set history=50
set incsearch
set infercase
set laststatus=2
set modeline
set modelines=5
set mouse=a
set nobackup
set noexpandtab
set nofoldenable
set nomore
set noshowcmd
set ruler
set scrolloff=5
set shiftround
set softtabstop=8
set showbreak=+++
set showmatch
set smarttab
function! CurDir()
	return substitute(getcwd(), $HOME."/*", "~/", "g")
endfunction
set statusline=%<%f\ %h%m\ \ \ \ %r%{CurDir()}%=%-14.(%l,%c%)\ %P\ [%L]
set suffixes+=.pyc,.pyo,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tabstop=8
set tags=tags;/
set textwidth=80
set viminfo='20,\"50
set whichwrap=<,>,[,],b,s
set wildcharm=<c-z>
set wildmenu
set winminheight=0

" Allow console menus.
"runtime menu.vim
"map <f10> :emenu <c-z>

" Use set list/nolist to activate.  To display the actual chars
" in the current encoding, use:	'set listchars?'
execute 'set listchars=' .
	\'eol:'   . nr2char(182) . ',' .
	\'tab:'   . nr2char(187) . nr2char(183) . ',' .
	\'trail:' . nr2char(183)

" Always do a preview with 'hardcopy'.
function! PrintFile(fname)
	call system('gv ' . a:fname)
	call delete(a:fname)
	return v:shell_error
endfunction
set printexpr=PrintFile(v:fname_in)
