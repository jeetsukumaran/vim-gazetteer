
if exists("g:loaded_gazetteer")
  finish
endif

if has('autocmd')
  augroup gazetteer
    autocmd!
    au BufRead * unlet! b:gazetteer_last_change
  augroup END
endif

nnoremap <silent> <Plug>GazetteerEchoLocation :call gazetteer#GazetteerEchoLocation()<CR>

if ( (!exists("g:gazetteer_suppress_keymaps") || !g:gazetter_suppress_keymaps) && !hasmapto("<Plug>GazetteerEchoLocation", "n") )
    nmap gG <Plug>GazetteerEchoLocation
endif
