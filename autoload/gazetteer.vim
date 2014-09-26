" Inspired by and including code derived from:
"   https://github.com/mklein-de/_vimfiles/blob/master/autoload/whereami.vi
let s:save_cpo = &cpo
set cpo&vim

let s:scope_resolution_operator_map = {
            \ "python" : "."
            \ }

if exists('g:ctrlp_gazetteer_ctags_bin') && g:ctrlp_gazetteer_ctags_bin != ''
    let s:bin = g:ctrlp_gazetteer_ctags_bin
else
    let s:bin = 'ctags'
endif

let s:types = {
            \ 'aspperl': '%sasp',
            \ 'aspvbs' : '%sasp',
            \ 'cpp'    : '%sc++',
            \ 'cs'     : '%sc#',
            \ 'cuda'   : '%sc++',
            \ 'expect' : '%stcl',
            \ 'csh'    : '%ssh',
            \ 'zsh'    : '%ssh',
            \ 'slang'  : '%sslang',
            \ }

cal map(s:types, 'printf(v:val, " --language-force=")')

if executable('jsctags')
    cal extend(s:types, { 'javascript': { 'args': '-f -', 'bin': 'jsctags' } })
endif

if exists('g:ctrlp_gazetteer_types')
    cal extend(s:types, g:ctrlp_gazetteer_types)
endif

" Adds a buffer variable, 'b:gazetteer_tags' that is a list of tuples, with
" the first element being the line number of a tag and the second element the
" tag definition
function! gazetteer#BuildBufferTagIndex(buf_num)
    let target_buf_num = a:buf_num
    if getbufvar(target_buf_num, "gazetteer_last_change", -1) != changenr()
        if &modified
            let file = tempname()
            silent exe ":w !cat > ".file
            let istmpfile = 1
        else
            let file = bufname(target_buf_num)
            let istmpfile = 0
        endif

        let [ags, ft] = ['-f - --fields=ks --excmd=num -u', getbufvar(target_buf_num, "&filetype")]
        if type(s:types[ft]) == 1
            let ags .= s:types[ft]
            let bin = s:bin
        elseif type(s:types[ft]) == 4
            let ags = s:types[ft]['args']
            let bin = expand(s:types[ft]['bin'], 1)
        endif

        let cmdline = bin . ' ' . ags
        let scope_resolution_operator = get(s:scope_resolution_operator_map, getbufvar(target_buf_num, "&filetype"), "::")
        " if exists("b:gazetteer_ctags_opts")
        "     let cmdline .= " ".shellescape(b:gazetteer_ctags_opts)
        " endif
        let cmdline .= " ".shellescape(file)
        let gazetteer_tags = []
        for ctags_line in split(system(cmdline), '\n')
            let a = split(ctags_line, '\t')
            if len(a) > 2
                if len(a) > 3
                    let kind = a[3]
                else
                    let kind = ""
                endif
                " c  classes
                " d  macro definitions
                " e  enumerators (values inside an enumeration)
                " f  function definitions
                " g  enumeration names
                " l  local variables
                " m  class, struct, and union members
                " n  namespaces
                " p  function prototypes
                " s  structure names
                " t  typedefs
                " u  union names
                " v  variable definitions
                " x  external and forward variable declarations
                if (kind == "" || kind == "c" || kind == "f" || kind == "g" || kind == "m" || kind == "s" || kind == "u")
                    let tag = a[0]
                    if len(a) > 4
                        let scope_type = substitute(a[4], ':.*$', '', '')
                        if (scope_type == "namespace" || scope_type == "class" || scope_type == "struct" || scope_type == "enum" || scope_type == "union")
                            let scope = substitute(a[4], '^[^:]*:', '', '')
                            let scopes = split(scope, "::")
                            if len(scopes) > 2
                                call remove(scopes, -2, -1)
                            endif
                            let tag = join(scopes, scope_resolution_operator).scope_resolution_operator.tag
                        endif
                    endif
                    call add(gazetteer_tags, [substitute(a[2], ';"', '', ''), tag])
                endif
            endif
        endfor
        if istmpfile
            call delete(file)
        endif
        call setbufvar(target_buf_num, "gazetteer_tags", gazetteer_tags)
        call setbufvar(target_buf_num, "gazetteer_last_change", changenr())
    endif
endfunction

function! gazetteer#WhereAmI()
    let curline = line(".")
    call gazetteer#BuildBufferTagIndex(bufnr("%"))
    " let gazetteer_tags = getbufvar(target_buf_num, "gazetteer_tags", [])
    let gazetteer_tags = b:gazetteer_tags
    let lb = 0
    let ub = len(gazetteer_tags)
    while ub > lb
        let tagnum = (lb + ub) / 2
        let tagline = gazetteer_tags[tagnum][0]
        if tagline == curline
            return gazetteer_tags[tagnum][1]
        else
            if tagline < curline
                let lb = tagnum + 1
            else
                let ub = tagnum
            endif
        endif
    endwhile
    if lb > 0 && gazetteer_tags[lb-1][0] < curline
        return gazetteer_tags[lb-1][1]
    endif
    return ""
endfun

function! gazetteer#GazetteerEchoLocation()
    let posv = getpos(".")
    let file_loc = '"' . expand('%:t') . '", Line ' . string(posv[1]) . ', Column ' . string(posv[2])
    let tag_name = gazetteer#WhereAmI()
    if empty(tag_name)
        let response = file_loc
    else
        let response = tag_name . " (" . file_loc . ")"
    endif
    echo response
endfunction

let &cpo = s:save_cpo
