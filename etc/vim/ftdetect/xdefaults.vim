autocmd BufNewFile,BufRead $HOME/\(*/\|\)etc/[Xx]resources/*
      \ if &ft =~# '^\%(conf\|modula2\|sh\)$' |
      \   set ft=xdefaults |
      \ else |
      \   setf xdefaults |
      \ endif
