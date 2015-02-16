" Inspired by and including code derived from:
"   https://github.com/mklein-de/_vimfiles/blob/master/autoload/whereami.vi
let s:save_cpo = &cpo
set cpo&vim

let s:scope_resolution_operator_map = {
            \ "python" : ".",
            \ "R" : "$"
            \ }

if exists('g:ctrlp_gazetteer_ctags_bin') && g:ctrlp_gazetteer_ctags_bin != ''
    let s:bin = g:ctrlp_gazetteer_ctags_bin
else
    let s:bin = 'ctags'
endif

" let s:ft_to_language_map = {
"             \ 'aspperl': '--language-force=asp',
"             \ 'aspvbs' : '--language-force=asp',
"             \ 'cpp'    : '--language-force=c++',
"             \ 'cs'     : '--language-force=c#',
"             \ 'cuda'   : '--language-force=c++',
"             \ 'expect' : '--language-force=tcl',
"             \ 'csh'    : '--language-force=sh',
"             \ 'zsh'    : '--language-force=sh',
"             \ 'slang'  : '--language-force=slang',
"             \ }
let s:ft_to_language_map = {
	\ 'asm'    : '%sasm%sasm%sdlmt',
	\ 'aspperl': '%sasp%sasp%sfsv',
	\ 'aspvbs' : '%sasp%sasp%sfsv',
	\ 'awk'    : '%sawk%sawk%sf',
	\ 'beta'   : '%sbeta%sbeta%sfsv',
	\ 'c'      : '%sc%sc%sdgsutvf',
	\ 'cpp'    : '%sc++%sc++%snvdtcgsuf',
	\ 'cs'     : '%sc#%sc#%sdtncEgsipm',
	\ 'cobol'  : '%scobol%scobol%sdfgpPs',
	\ 'eiffel' : '%seiffel%seiffel%scf',
	\ 'erlang' : '%serlang%serlang%sdrmf',
	\ 'expect' : '%stcl%stcl%scfp',
	\ 'fortran': '%sfortran%sfortran%spbceiklmntvfs',
	\ 'html'   : '%shtml%shtml%saf',
	\ 'java'   : '%sjava%sjava%spcifm',
	\ 'javascript': '%sjavascript%sjavascript%sf',
	\ 'lisp'   : '%slisp%slisp%sf',
	\ 'lua'    : '%slua%slua%sf',
	\ 'make'   : '%smake%smake%sm',
	\ 'ocaml'  : '%socaml%socaml%scmMvtfCre',
	\ 'pascal' : '%spascal%spascal%sfp',
	\ 'perl'   : '%sperl%sperl%sclps',
	\ 'php'    : '%sphp%sphp%scdvf',
	\ 'python' : '%spython%spython%scmf',
	\ 'rexx'   : '%srexx%srexx%ss',
	\ 'ruby'   : '%sruby%sruby%scfFm',
	\ 'scheme' : '%sscheme%sscheme%ssf',
	\ 'sh'     : '%ssh%ssh%sf',
	\ 'csh'    : '%ssh%ssh%sf',
	\ 'zsh'    : '%ssh%ssh%sf',
	\ 'scala'  : '%sscala%sscala%sctTmlp',
	\ 'slang'  : '%sslang%sslang%snf',
	\ 'sml'    : '%ssml%ssml%secsrtvf',
	\ 'sql'    : '%ssql%ssql%scFPrstTvfp',
	\ 'tcl'    : '%stcl%stcl%scfmp',
	\ 'vera'   : '%svera%svera%scdefgmpPtTvx',
	\ 'verilog': '%sverilog%sverilog%smcPertwpvf',
	\ 'vim'    : '%svim%svim%savf',
	\ 'yacc'   : '%syacc%syacc%sl',
	\ }
call map(s:ft_to_language_map, 'printf(v:val, "--language-force=", " --", "-types=")')

if executable('jsctags')
    call extend(s:ft_to_language_map, { 'javascript': { 'args': '-f -', 'bin': 'jsctags' } })
endif

" if executable('markdown2ctags.py')
"     call extend(s:ft_to_language_map, { 'markdown': { 'args': '-f -', 'bin': 'markdown2ctags.py' } })
"     call extend(s:ft_to_language_map, { 'pandoc': { 'args': '-f -', 'bin': 'markdown2ctags.py' } })
" endif

let s:_markdownlike_ctags = " --langdef=markdown"
let s:_markdownlike_ctags .= " --regex-markdown='" . '/^#[[:space:]]*([^#].+)$/\1/s,section/' . "'"
let s:_markdownlike_ctags .= " --regex-markdown='" . '/^##[[:space:]]*([^#].+)$/\1/s,subsection/' . "'"
let s:_markdownlike_ctags .= " --regex-markdown='" . '/^###[[:space:]]*([^#].+)$/\1/s,subsubsection/' . "'"
let s:_markdownlike_ctags .= " --regex-markdown='" . '/^####[[:space:]]*([^#].+)$/\1/s,subsubsubsection/' . "'"
let s:_markdownlike_ctags .= " --language-force=markdown "
let s:ft_to_language_map["markdown"] = s:_markdownlike_ctags
let s:ft_to_language_map["pandoc"] = s:_markdownlike_ctags

let s:_rstats_ctags = " --langdef=R"
let s:_rstats_ctags .= " --regex-R='" . '/^[ \t]*"?([.A-Za-z][.A-Za-z0-9_]*)"?[ \t]*(<-|=)[ \t]function/\1/f,Functions/' . "'"
let s:_rstats_ctags .= " --regex-R='" . '/^"?([.A-Za-z][.A-Za-z0-9_]*)"?[ \t]*(<-|=)[ \t][^f][^u][^n][^c][^t][^i][^o][^n]/\1/g,GlobalVars/' . "'"
" let s:_rstats_ctags .= " --regex-R='" . '/[ \t]"?([.A-Za-z][.A-Za-z0-9_]*)"?[ \t]*(<-|=)[ \t][^f][^u][^n][^c][^t][^i][^o][^n]/\1/v,FunctionVariables/' . "'"
let s:_rstats_ctags .= " --language-force=R "
let s:ft_to_language_map["R"] = s:_rstats_ctags
let s:ft_to_language_map["r"] = s:_rstats_ctags

if exists('g:ctrlp_gazetteer_types')
    call extend(s:ft_to_language_map, g:ctrlp_gazetteer_types)
endif

function! s:_get_tag_generation_cmd(target_buf_num)
    let ags = '-f - --fields=ks --excmd=num -u'
    let ft = getbufvar(a:target_buf_num, "&filetype")
    let lang_for_ft = get(s:ft_to_language_map, ft, ft)
    if type(lang_for_ft) == 1
        let ags .= " " . lang_for_ft
        let bin = s:bin
    elseif type(lang_for_ft) == 4
        let ags = " " . lang_for_ft['args']
        let bin = expand(lang_for_ft['bin'], 1)
    endif
    let cmdline = bin . ' ' . ags
    " echomsg cmdline
    return cmdline
endfunction

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
        let cmdline = s:_get_tag_generation_cmd(target_buf_num)
        let scope_resolution_operator = get(s:scope_resolution_operator_map, getbufvar(target_buf_num, "&filetype"), "::")
        " if exists("b:gazetteer_ctags_opts")
        "     let cmdline .= " ".shellescape(b:gazetteer_ctags_opts)
        " endif
        let cmdline .= " ".shellescape(file)
        echomsg cmdline
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
                if (kind == "" || kind == "c" || kind == "f" || kind == "g" || kind == "m" || kind == "s" || kind == "u" || kind == "s")
                    let tag = a[0]
                    if len(a) > 4
                        let scope_type = substitute(a[4], ':.*$', '', '')
                        if (scope_type == "namespace" || scope_type == "class" || scope_type == "struct" || scope_type == "enum" || scope_type == "union")
                            let scope = substitute(a[4], '^[^:]*:', '', '')
                            let scopes = split(scope, "::")
                            if len(scopes) > 2
                                call remove(scopes, -2, -1)
                            endif
                            " let tag = join(scopes, scope_resolution_operator) . scope_resolution_operator . tag
                            let tag = join(scopes, '/') . '/' .tag
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
    redraw
    echo response
endfunction

let &cpo = s:save_cpo
