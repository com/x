autocmd BufNewFile,BufRead $HOME/\(*/\|\)etc/tmux/*,*/etc/\(tmux\)/*,*\.tmux*
      \ if &ft =~# '^\%(conf\|modula2\|sh\)$' |
      \   set ft=tmux |
      \ else |
      \   setf tmux |
      \ endif
