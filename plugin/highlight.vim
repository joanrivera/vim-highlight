" File: highlight.vim
" Description: Highlight lines or patterns of interest in different colors
" Usage:
"   Ex mode
"     :Highlight <mode>   Highlight depending on <mode> (Ex. :Highlight h)
"
" Modes:
"   h   Highlight line
"   w   Highlight word under cursor (whole word match)
"   f   Highlight word under cursor (partial word match)
"   l   Highlight lines having word under cursor (whole word match)
"   k   Highlight lines having word under cursor (partial word matching)
"   s   Highlight last search pattern
"   j   Highlight all lines having last search pattern
"   a   Change color for next highlight group
"   r   Clear last highlight group
"   d   Clear last pattern highlight
"   n   Clear all highlights
"
" Installation:
"   Copy highlight.vim to your .vim/plugin directory
"
" Configuration:
"   To define custom colors set the following variables
"     g:lcolor_bg - Background color for line highlighting
"     g:lcolor_fg - Foreground color for line highlighting
"     g:pcolor_bg - Background color for pattern highlighting
"     g:pcolor_fg - Foreground color for pattern highlighting
"
" Limitation:
"   If you are using syntax highlighting based on keywords (e.g. language
"   specific keyword highlighting), then while highlighting lines, if the
"   line starts with a keyword, then sometimes that keyword is not highlighted,
"   while the rest of the line is hightlighted normally.
"
"
" Acknowledgement:
"   Thanks to Amit Sethi <amitrajsethi@yahoo.com> for create the original
"   script


if exists("g:loaded_highlight_plugin")
   finish
endif
let g:loaded_highlight_plugin = 1

" syntax on

" Define colors for Line highlight
if !exists('g:lcolor_bg')
   let g:lcolor_bg = "purple,seagreen,violet,lightred,lightgreen,lightblue,darkmagenta,slateblue"
endif

if !exists('g:lcolor_fg')
   let g:lcolor_fg = "white,white,black,black,black,black,white,white"
endif

if !exists('g:lcolor_bg_cterm')
   let g:lcolor_bg_cterm = "Blue,Green,Cyan,Red,Yellow,Magenta,Brown,LightGray"
endif

if !exists('g:lcolor_fg_cterm')
   let g:lcolor_fg_cterm = "White,White,White,White,White,White,Black,Black"
endif

" Define colors for Pattern highlight
if !exists('g:pcolor_bg')
   let g:pcolor_bg = "yellow,blue,green,magenta,cyan,brown,orange,red"
endif

if !exists('g:pcolor_fg')
   let g:pcolor_fg = "black,white,black,white,black,white,black,white"
endif

if !exists('g:pcolor_bg_cterm')
   let g:pcolor_bg_cterm = "DarkBlue,DarkGreen,DarkCyan,DarkRed,Yellow,Magenta,Brown,LightGray"
endif

if !exists('g:pcolor_fg_cterm')
   let g:pcolor_fg_cterm = "White,Black,White,White,White,White,Black,Black"
endif


" Highlight: Highlight line or pattern
function! Highlight(mode)
   " Line mode
   if a:mode == 'h'
      let match_pat = '.*\%'.line(".").'l.*'
      " echo 'syn match '. s:lcolor_grp . s:lcolor_n . ' "' . match_pat . '" containedin=ALL'
      exec 'syn match '. s:lcolor_grp . s:lcolor_n . ' "' . match_pat . '" containedin=ALL'
   elseif a:mode == 'a'
      let s:lcolor_n = s:lcolor_n == s:lcolor_max - 1 ? 0 : s:lcolor_n + 1
   elseif a:mode == 'r'
      exec 'syn clear ' . s:lcolor_grp . s:lcolor_n
      let s:lcolor_n = s:lcolor_n == 0 ? 0 : s:lcolor_n - 1
   else
   endif

   let cur_word = a:mode == 's' || a:mode == 'j' ? @/ : expand("<cword>")

   " Pattern mode
   if cur_word == ""
      " do nothing
   elseif a:mode == 'f' || a:mode == 's'
      let s:pcolor_n = s:pcolor_n == s:pcolor_max - 1 ?  1 : s:pcolor_n + 1
      exec 'syn match ' . s:pcolor_grp . s:pcolor_n . ' "' . cur_word . '" containedin=ALL'
   elseif a:mode == 'w'
      let s:pcolor_n = s:pcolor_n == s:pcolor_max - 1 ?  1 : s:pcolor_n + 1
      exec 'syn match ' . s:pcolor_grp . s:pcolor_n . ' "\<' . cur_word . '\>" containedin=ALL'
   elseif a:mode == 'k' || a:mode == 'j'
      let s:pcolor_n = s:pcolor_n == s:pcolor_max - 1 ?  1 : s:pcolor_n + 1
      exec 'syn match ' . s:pcolor_grp . s:pcolor_n . ' ".*' . cur_word . '.*" containedin=ALL'
   elseif a:mode == 'l'
      let s:pcolor_n = s:pcolor_n == s:pcolor_max - 1 ?  1 : s:pcolor_n + 1
      exec 'syn match ' . s:pcolor_grp . s:pcolor_n . ' ".*\<' . cur_word . '\>.*" containedin=ALL'
   elseif a:mode == 'd'
      exec 'syn clear ' . s:pcolor_grp . s:pcolor_n
      let s:pcolor_n = s:pcolor_n == 0 ? 0 : s:pcolor_n - 1
   else
   endif

   " Clean all
   if a:mode == 'n'
      let ccol = 0
      while ccol < s:lcolor_max
         exec 'syn clear '. s:lcolor_grp . ccol
         let ccol = ccol + 1
      endw

      let ccol = 0
      while ccol < s:pcolor_max
         exec 'syn clear '. s:pcolor_grp . ccol
         let ccol = ccol + 1
      endw

      let s:lcolor_n = 0
      let s:pcolor_n = 0
   else
   endif

endfunction

" Strntok: Utility function to implement C-like strntok() by Michael Geddes
" and Benji Fisher at http://groups.yahoo.com/group/vimdev/message/26788
function! s:Strntok( s, tok, n)
    return matchstr( a:s.a:tok[0], '\v(\zs([^'.a:tok.']*)\ze['.a:tok.']){'.a:n.'}')
endfun

" ItemCount: Returns the number of items in the given string.
" Developed by Dan Sharp in MultipleSearch2.vim at
" http://www.vim.org/scripts/script.php?script_id=1183
function! s:ItemCount(string)
    let itemCount = 0
    let newstring = a:string
    let pos = stridx(newstring, ',')
    while pos > -1
        let itemCount = itemCount + 1
        let newstring = strpart(newstring, pos + 1)
        let pos = stridx(newstring, ',')
    endwhile
    return itemCount
endfunction

" Min: Returns the minimum of the given parameters.
" Developed by Dan Sharp in MultipleSearch2.vim at
" http://www.vim.org/scripts/script.php?script_id=1183
function! s:Min(...)
    let min = a:1
    let index = 2
    while index <= a:0
        execute "if min > a:" . index . " | let min = a:" . index . " | endif"
        let index = index + 1
    endwhile
    return min
endfunction

" HighlightInitL: Initialize the highlight groups for line highlight
" Based on 'MultipleSearchInit' function developed by Dan Sharp in
" MultipleSearch2.vim at http://www.vim.org/scripts/script.php?script_id=1183
function! s:HighlightInitL()
   let s:lcolor_grp = "LHiColor"
   let s:lcolor_n = 0

   let s:lcolor_max = s:Min(s:ItemCount(g:lcolor_bg . ','), s:ItemCount(g:lcolor_fg . ','))

   let ci = 0
   while ci < s:lcolor_max
      let bgColor = s:Strntok(g:lcolor_bg, ',', ci + 1)
      let fgColor = s:Strntok(g:lcolor_fg, ',', ci + 1)
      let bgColor_cterm = s:Strntok(g:lcolor_bg_cterm, ',', ci + 1)
      let fgColor_cterm = s:Strntok(g:lcolor_fg_cterm, ',', ci + 1)

      exec 'hi ' . s:lcolor_grp . ci .
         \ ' guifg =' . fgColor . ' guibg=' . bgColor
         \ ' ctermfg =' . fgColor_cterm . ' ctermbg=' . bgColor_cterm

      let ci = ci + 1
   endw
endfunction

" HighlightInitP: Initialize the highlight groups for line highlight
" Based on 'MultipleSearchInit' function developed by Dan Sharp in
" MultipleSearch2.vim at http://www.vim.org/scripts/script.php?script_id=1183
function! s:HighlightInitP()
   let s:pcolor_grp = "PHiColor"
   let s:pcolor_n = 0

   let s:pcolor_max = s:Min(s:ItemCount(g:pcolor_bg . ','), s:ItemCount(g:pcolor_fg . ','))

   let ci = 0
   while ci < s:pcolor_max
      let bgColor = s:Strntok(g:pcolor_bg, ',', ci + 1)
      let fgColor = s:Strntok(g:pcolor_fg, ',', ci + 1)
      let bgColor_cterm = s:Strntok(g:pcolor_bg_cterm, ',', ci + 1)
      let fgColor_cterm = s:Strntok(g:pcolor_fg_cterm, ',', ci + 1)

      exec 'hi ' . s:pcolor_grp . ci .
         \ ' guifg =' . fgColor . ' guibg=' . bgColor
         \ ' ctermfg =' . fgColor_cterm . ' ctermbg=' . bgColor_cterm

      let ci = ci + 1
   endw
endfunction


function! HighlightInit()
    call s:HighlightInitL()
    call s:HighlightInitP()
endfunction

call HighlightInit()


command! -nargs=1 Highlight call Highlight(<q-args>)


autocmd ColorScheme * :call HighlightInit()
