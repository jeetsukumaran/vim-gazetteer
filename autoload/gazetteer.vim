let s:save_cpo = &cpo
set cpo&vim

let s:scope_resolution_operator_map = {
            \ "python" : "."
            \ }

" based on: https://github.com/mklein-de/_vimfiles/blob/master/autoload/whereami.vim
function! gazetteer#WhereAmI(buf_num)
    let posv = getpos(a:buf_num)
    let target_buf_num = a:buf_num

    " let old_lazyredraw = &lazyredraw
    " set lazyredraw
    " let savebuf = bufnr("%")
    " execute "keepjumps keepalt buffer " . string(target_buf_num)
    let curline = line(".")
    " execute "keepjumps keepalt buffer " . string(savebuf)
    " let &lazyredraw = old_lazyredraw
    " return

    " if &cindent
    "     let curline = searchpair('{', '', '}', 'cbnW')
    "     if curline == 0
    "         return "(no scope)"
    "     endif
    " else
    "     let curline = line(".")
    " endif
    if getbufvar(target_buf_num, "gazetteer_last_change", -1) != changenr()
        if &modified
            let file = tempname()
            silent exe ":w !cat > ".file
            let istmpfile = 1
        else
            let file = bufname(target_buf_num)
            let istmpfile = 0
        endif
        let cmdline = 'ctags -f - --fields=Ks --excmd=num -u --language-force='
        if getbufvar(target_buf_num, "&filetype") == 'cpp'
            let cmdline .= 'c++'
        else
            let cmdline .= getbufvar(target_buf_num, "&filetype")
        endif
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
                if kind != "namespace" && kind != "variable"
                    let tag = a[0]
                    if len(a) > 4
                        let scope = substitute(a[4], '^[^:]*:', '', '')
                        let scopes = split(scope, "::")
                        if len(scopes) > 2
                            call remove(scopes, -2, -1)
                        endif
                        let tag = join(scopes, scope_resolution_operator).scope_resolution_operator.tag
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
    let lb = 0
    let gazetteer_tags = getbufvar(target_buf_num, "gazetteer_tags", [])
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
    let tag_name = gazetteer#WhereAmI(bufnr("%"))
    if empty(tag_name)
        let response = file_loc
    else
        let response = tag_name . " (" . file_loc . ")"
    endif
    echo response
endfunction

let &cpo = s:save_cpo
