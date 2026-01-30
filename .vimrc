" paste mode toggle (F2)
set pastetoggle=<F2>

" bracketed paste (auto detect paste in terminal)
if &term =~ 'xterm\|tmux\|screen'
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
  function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
  endfunction
endif

" basic settings
set number
set encoding=utf-8
set nocompatible
set backspace=indent,eol,start
