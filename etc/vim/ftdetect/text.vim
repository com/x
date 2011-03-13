" Note that, there is no such text type in VIM distribution.
" Files with all upper case names are accepted as text files.
autocmd BufNewFile,BufRead *.w3m/w3mtmp*,*.txt,[A-Z]\+
      \ if &ft =~# '^\%(conf\|modula2\)$' |
      \   set ft=text |
      \ else |
      \   setf text |
      \ endif
