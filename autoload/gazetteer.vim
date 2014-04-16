let s:save_cpo = &cpo
set cpo&vim

let s:scope_resolution_operator_map = {
            \ "python" : "."
            \ }

" based on: https://github.com/mklein-de/_vimfiles/blob/master/autoload/whereami.vim
function! s:_whereami()
    if &cindent
        let curline = searchpair('{', '', '}', 'cbnW')
        if curline == 0
            return "(no scope)"
        endif
    else
        let curline = line(".")
    endif
    if !exists("b:gazetteer_last_change") || b:gazetteer_last_change != changenr()
        if &modified
            let file = tempname()
            silent exe ":w !cat > ".file
            let istmpfile = 1
        else
            let file = expand("%")
            let istmpfile = 0
        endif
        let cmdline = 'ctags -f - --fields=Ks --excmd=num -u --language-force='
        if &filetype == 'cpp'
            let cmdline .= 'c++'
        else
            let cmdline .= &filetype
        endif
        let scope_resolution_operator = get(s:scope_resolution_operator_map, &filetype, "::")
        if exists("b:gazetteer_ctags_opts")
            let cmdline .= " ".shellescape(b:gazetteer_ctags_opts)
        endif
        let cmdline .= " ".shellescape(file)
        let b:gazetteer_tags = []
        for ctags_line in split(system(cmdline), '\n')
            let a = split(ctags_line, '\t')
            if len(a) > 2
                let tag = a[0]
                if len(a) > 4
                    let scope = substitute(a[4], '^[^:]*:', '', '')
                    let scopes = split(scope, "::")
                    if len(scopes) > 2
                        call remove(scopes, -2, -1)
                    endif
                    let tag = join(scopes, scope_resolution_operator).scope_resolution_operator.tag
                endif
                " if len(a) > 3
                "     let kind = a[3]
                "     let tag = kind . " " . tag
                    " if kind == 'c'
                    "     let tag = "class ".tag
                    " elseif kind == 'f'
                    "     let tag = tag."()"
                    " elseif kind == 'm'
                    " elseif kind == 'g'
                    "     let tag = "enum ".tag
                    " elseif kind == 'n'
                    "     let tag = "namespace ".tag
                    " elseif kind == 's'
                    "     let tag = "struct ".tag
                    " elseif kind == 'u'
                    "     let tag = "union ".tag
                    " elseif kind == 'i'
                    "     let tag = "import ".tag
                    " elseif kind == 'v'
                    "     let tag = "variable ".tag
                    " else
                    "     throw 'unhandled kind: ' . kind
                    " endif
                " endif
                call add(b:gazetteer_tags, [substitute(a[2], ';"', '', ''), tag])
            endif
        endfor
        if istmpfile
            call delete(file)
        endif
        let b:gazetteer_last_change = changenr()
    endif
    let lb = 0
    let ub = len(b:gazetteer_tags)
    while ub > lb
        let tagnum = (lb + ub) / 2
        let tagline = b:gazetteer_tags[tagnum][0]
        if tagline == curline
            return b:gazetteer_tags[tagnum][1]
        else
            if tagline < curline
                let lb = tagnum + 1
            else
                let ub = tagnum
            endif
        endif
    endwhile
    if lb > 0 && b:gazetteer_tags[lb-1][0] < curline
        return b:gazetteer_tags[lb-1][1]
    endif
    return ""
endfun

function! gazetteer#GazetteerEchoLocation()
    let posv = getpos(".")
    let file_loc = '"' . expand('%:t') . '", Line ' . string(posv[1]) . ', Column ' . string(posv[2])
    let tag_name = s:_whereami()
    if empty(tag_name)
        let response = file_loc
    else
        let response = tag_name . " (" . file_loc . ")"
    endif
    echo response
endfunction

let &cpo = s:save_cpo
