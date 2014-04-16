" =============================================================================
" File:          autoload/ctrlp/gazetteer.vim
" Description:   ctrlp menu extension for ctrlp.vim
" =============================================================================

" Change the name of the g:loaded_ variable to make it unique
if ( exists('g:loaded_ctrlp_gazetteer') && g:loaded_ctrlp_gazetteer )
      \ || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_gazetteer = 1

" The main variable for this extension.
"
" The values are:
" + the name of the input function (including the brackets and any argument)
" + the name of the action function (only the name)
" + the long and short names to use for the statusline
" + the matching type: line, path, tabs, tabe
"                      |     |     |     |
"                      |     |     |     `- match last tab delimited str
"                      |     |     `- match first tab delimited str
"                      |     `- match full line like file/dir path
"                      `- match full line
let s:ctrlp_var = {
      \ 'init'  : 'ctrlp#gazetteer#init(s:crbufnr)',
      \ 'accept': 'ctrlp#gazetteer#accept',
      \ 'lname' : 'gazetteer',
      \ 'sname' : 'gazetteer',
      \ 'type'  : 'path',
      \ 'sort'  : 0,
      \ 'nolim' : 1,
      \ }


" Append s:ctrlp_var to g:ctrlp_ext_vars
if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:ctrlp_var)
else
  let g:ctrlp_ext_vars = [s:ctrlp_var]
endif

" Provide a list of strings to search in
"
" Return: command
function! ctrlp#gazetteer#init(buf_num)
  call gazetteer#WhereAmI(a:buf_num)
  let s:gazetteer_ctrlp_tag_list = []
  let s:gazetteer_ctrlp_tag_map = {}
  for item in getbufvar(a:buf_num, "gazetteer_tags", [])
    let entry = substitute(item[1], '\(\.\|::\)', '/', 'g')
    call add(s:gazetteer_ctrlp_tag_list, entry)
    let s:gazetteer_ctrlp_tag_map[entry] = item[0]
  endfor
  return s:gazetteer_ctrlp_tag_list
endfunction


" The action to perform on the selected string.
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
func! ctrlp#gazetteer#accept(mode, str)
  call ctrlp#exit()
  try
      let l:jump_to_lnum = s:gazetteer_ctrlp_tag_map[a:str]
      call setpos('.', [0, l:jump_to_lnum, 1, 1])
  catch /E716:/
      redraw
      echohl WarningMsg
      echomsg "Not found: " . l:term
      echohl None
  endtry
endfunc

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
" Allow it to be called later
function! ctrlp#gazetteer#id()
  return s:id
endfunction

function! ctrlp#gazetteer#gazetteer(word)
  let s:winnr = winnr()
  try
    if !empty(a:word)
      let default_input_save = get(g:, 'ctrlp_default_input', '')
      let g:ctrlp_default_input = a:word
    endif
    call ctrlp#init(ctrlp#gazetteer#id())
  finally
    if exists('default_input_save')
      let g:ctrlp_default_input = default_input_save
    endif
  endtry
endfunction


" vim:fen:fdl=0:ts=2:sw=2:sts=2
