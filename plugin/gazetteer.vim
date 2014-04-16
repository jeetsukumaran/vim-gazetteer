
if exists("g:loaded_gazetteer")
  finish
endif

if has('autocmd')
  augroup gazetteer
    autocmd!
    au BufRead * unlet! b:gazetteer_last_change
  augroup END
endif

command! -nargs=? CtrlPGazetteer :call ctrlp#gazetteer#gazetteer(<q-args>)
nnoremap <silent> <Plug>GazetteerEchoLocation :call gazetteer#GazetteerEchoLocation()<CR>
nnoremap <silent> <Plug>CtrlPGazetteer :CtrlPGazetteer<CR>

if ( (!exists("g:gazetteer_suppress_keymaps") || !g:gazetteer_suppress_keymaps)  )
    if !hasmapto("<Plug>GazetteerEchoLocation", "n")
        nmap gG <Plug>GazetteerEchoLocation
    endif
    if !hasmapto("<Plug>CtrlPGazetteer", "n")
        nmap g@ <Plug>CtrlPGazetteer
    endif
endif
