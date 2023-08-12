" camelcasemotion.vim: Motion through CamelCaseWords and underscore_notation.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"
" ACKNOWLEDGEMENTS:
"   - This script was created by Ingo Karkat <ingo@karkat.de>
"   - This version of this script is spliced together from the CamelCaseMotion plugin (https://github.com/bkad/CamelCaseMotion)
"
" COPYRIGHT: (C) 2007-2009 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.

"- functions ------------------------------------------------------------------"
" Avoid installing twice or when in compatible mode
if exists('g:loaded_camelcasemotion') || (v:version < 700)
  finish
endif

let g:loaded_camelcasemotion = 1

if exists('g:camelcasemotion_key')
  call camelcasemotion#CreateMotionMappings(g:camelcasemotion_key)
endif

"- mappings -------------------------------------------------------------------
" The count is passed into the function through the special variable 'v:count1',
" which is easier than misusing the :[range] that :call supports.
" <C-U> is used to delete the unused range.
" Another option would be to use a custom 'command! -count=1', but that doesn't
" work with the normal mode mapping: When a count is typed before the mapping,
" the ':' will convert a count of 3 into ':.,+2MyCommand', but ':3MyCommand'
" would be required to use -count and <count>.
"
" We do not provide the fourth "backward to end" motion (,E), because it is
" seldomly used.

for s:mode in ['n', 'o', 'v']
  for s:motion in ['w', 'b', 'e', 'ge']
    let s:targetMapping = '<Plug>CamelCaseMotion_' . s:motion
    execute s:mode . 'noremap <silent> ' . s:targetMapping .
          \ ' :<C-U>call camelcasemotion#Motion(''' . s:motion . ''',v:count1,''' . s:mode . ''')<CR>'
  endfor
endfor

" To create a text motion, a mapping for operator-pending mode needs to be
" defined. This mapping should move the cursor according to the implemented
" motion, or mark the covered text via a visual selection. As inner text motions
" need to mark both to the left and right of the cursor position, the visual
" selection needs to be used.
"
" Vim's built-in inner text objects also work in visual mode; they have
" different behavior depending on whether visual mode has just been entered or
" whether text has already been selected.
" We deviate from that and always override the existing selection.

for s:mode in ['o', 'v']
  for s:motion in ['w', 'b', 'e', 'ge']
    let s:targetMapping = '<Plug>CamelCaseMotion_i' . s:motion
    execute s:mode . 'noremap <silent> ' . s:targetMapping .
          \ ' :<C-U>call camelcasemotion#InnerMotion(''' . s:motion . ''',v:count1)<CR>'
  endfor
endfor

let s:forward_to_end_list = []
call add(s:forward_to_end_list, '\d+')                  " number
call add(s:forward_to_end_list, '\u+\ze%(\u\l|\d)')     " ALLCAPS followed by CamelCase or number
call add(s:forward_to_end_list, '\l+\ze%(\u|\d)')       " lowercase followed by ALLCAPS
call add(s:forward_to_end_list, '\u\l+')                " CamelCase
call add(s:forward_to_end_list, '%(\a|\d)+\ze[\-_]')    " underscore_notation
call add(s:forward_to_end_list, '%(\k@!\S)+')           " non-keyword
call add(s:forward_to_end_list, '%([\-_]@!\k)+>')       " word
let s:forward_to_end = '\v' . join(s:forward_to_end_list, '|')

let s:forward_to_next_list = []
call add(s:forward_to_next_list, '<\D')                            " word
call add(s:forward_to_next_list, '^$')                             " empty line
call add(s:forward_to_next_list, '%(^|\s)+\zs\k@!\S')              " non-keyword after whitespaces
call add(s:forward_to_next_list, '><')                             " non-whitespace after word
call add(s:forward_to_next_list, '[\{\}\[\]\(\)\<\>\&"'."'".']')   " brackets, parens, braces, quotes
call add(s:forward_to_next_list, '\d+')                            " number
call add(s:forward_to_next_list, '\l\+\zs%(\u|\d)')                " lowercase followed by capital letter or number
call add(s:forward_to_next_list, '\u+\zs%(\u\l|\d)')               " ALLCAPS followed by CamelCase or number
call add(s:forward_to_next_list, '\u\l+')                          " CamelCase
call add(s:forward_to_next_list, '\u@<!\u+')                       " ALLCAPS
call add(s:forward_to_next_list, '[\-_]\zs%(\u\+|\u\l+|\l+|\d+)')  " underscored followed by ALLCAPS, CamelCase, lowercase, or number
let s:forward_to_next = '\v' . join(s:forward_to_next_list, '|')

function! s:Move(direction, count, mode)
  " Note: There is no inversion of the regular expression character class
  " 'keyword character' (\k). We need an inversion "non-keyword" defined as
  " "any non-whitespace character that is not a keyword character" (e.g.
  " [!@#$%^&*()]). This can be specified via a non-whitespace character in
  " whose place no keyword character matches (\k\@!\S).

  let l:i = 0
  while l:i < a:count
    if a:direction == 'e' || a:direction == 'ge'
      " "Forward to end" motion.
      let l:direction = (a:direction == 'e' ? a:direction : 'be')
      call search(s:forward_to_end, 'W' . l:direction)
      " Note: word must be defined as '\k\>'; '\>' on its own somehow
      " dominates over the previous branch. Plus, \k must exclude the
      " underscore, or a trailing one will be incorrectly moved over:
      " '\%(_\@!\k\)'.
      if a:mode == 'o'
        " Note: Special additional treatment for operator-pending mode
        " "forward to end" motion.
        " The difference between normal mode, operator-pending and visual
        " mode is that in the latter two, the motion must go _past_ the
        " final "word" character, so that all characters of the "word" are
        " selected. This is done by appending a 'l' motion after the
        " search for the next "word".
        "
        " In operator-pending mode, the 'l' motion only works properly
        " at the end of the line (i.e. when the moved-over "word" is at
        " the end of the line) when the 'l' motion is allowed to move
        " over to the next line. Thus, the 'l' motion is added
        " temporarily to the global 'whichwrap' setting.
        " Without this, the motion would leave out the last character in
        " the line. I've also experimented with temporarily setting
        " "set virtualedit=onemore" , but that didn't work.
        let l:save_ww = &whichwrap
        set whichwrap+=l
        normal! l
        let &whichwrap = l:save_ww
      endif
    else
      " Forward (a:direction == '') and backward (a:direction == 'b')
      " motion.

      let l:direction = (a:direction == 'w' ? '' : a:direction)

      call search(s:forward_to_next, 'W' . l:direction)
      " Note: word must be defined as '\<\D' to avoid that a word like
      " 1234Test is moved over as [1][2]34[T]est instead of [1]234[T]est
      " because \< matches with zero width, and \d\+ will then start
      " matching '234'. To fix that, we make \d\+ be solely responsible
      " for numbers by taken this away from \< via \<\D. (An alternative
      " would be to replace \d\+ with \D\%#\zs\d\+, but that one is more
      " complex.) All other branches are not affected, because they match
      " multiple characters and not the same character multiple times.
    endif
    let l:i = l:i + 1
  endwhile
endfunction

function! camelcasemotion#Motion(direction, count, mode)
  "*******************************************************************************
  "* PURPOSE:
  "   Perform the motion over CamelCaseWords or underscore_notation.
  "* ASSUMPTIONS / PRECONDITIONS:
  "   none
  "* EFFECTS / POSTCONDITIONS:
  "   Move cursor / change selection.
  "* INPUTS:
  "   a:direction  one of 'w', 'b', 'e'
  "   a:count  number of "words" to move over
  "   a:mode  one of 'n', 'o', 'v', 'iv' (latter one is a special visual mode
  "    when inside the inner "word" text objects.
  "* RETURN VALUES:
  "   none
  "*******************************************************************************
  " Visual mode needs special preparations and postprocessing;
  " normal and operator-pending mode breeze through to s:Move().

  if a:mode == 'v'
    " Visual mode was left when calling this function. Reselecting the current
    " selection returns to visual mode and allows to call search() and issue
    " normal mode motions while staying in visual mode.
    normal! gv
  endif
  if a:mode == 'v' || a:mode == 'iv'
    " Note_1a:
    if &selection != 'exclusive' && a:direction == 'w'
      normal! l
    endif
  endif

  call s:Move(a:direction, a:count, a:mode)

  if a:mode == 'v' || a:mode == 'iv'
    " Note: 'selection' setting.
    if &selection == 'exclusive' && (a:direction == 'e' || a:direction == 'ge')
      " When set to 'exclusive', the "forward to end" motion (',e') does not
      " include the last character of the moved-over "word". To include that, an
      " additional 'l' motion is appended to the motion; similar to the
      " special treatment in operator-pending mode.
      normal! l
    elseif &selection != 'exclusive' && (
          \ (a:direction != 'e' && a:direction == 'ge')
          \ || (a:mode == 'iv' && a:direction == 'w'))
      " Note_1b:
      " The forward and backward motions move to the beginning of the next "word".
      " When 'selection' is set to 'inclusive' or 'old', this is one character too far.
      " The appended 'h' motion undoes this. Because of this backward step,
      " though, the forward motion finds the current "word" again, and would
      " be stuck on the current "word". An 'l' motion before the CamelCase
      " motion (see Note_1a) fixes that.
      " Note_1c:
      " A similar problem applies when selecting a whole inner "word": the
      " cursor moves to the beginning of the next "word" which for an
      " inclusive selection, at least in operator-pending mode, leads to
      " counter-intuitive results. (See github issues #28 and #31.) The
      " appended 'h' is needed in that case as well. Possibly for 'v' mode
      " too.
      normal! h
    endif
  endif
  if &foldopen =~# 'hor\|all'
    normal! zv
  endif
endfunction

function! camelcasemotion#InnerMotion(direction, count)
  " If the cursor is positioned on the first character of a CamelWord, the
  " backward motion would move to the previous word, which would result in a
  " wrong selection. To fix this, first move the cursor to the right, so that
  " the backward motion definitely will cover the current "word" under the
  " cursor.
  normal! l

  " Move "word" backwards, enter visual mode, then move "word" forward. This
  " selects the inner "word" in visual mode; the operator-pending mode takes
  " this selection as the area covered by the motion.
  if a:direction == 'b'
    " Do not do the selection backwards, because the backwards "word" motion
    " in visual mode + selection=inclusive has an off-by-one error.
    call camelcasemotion#Motion('b', a:count, 'n')
    normal! v
    " We decree that 'b' is the opposite of 'e', not 'w'. This makes more
    " sense at the end of a line and for underscore_notation.
    call camelcasemotion#Motion('e', a:count, 'iv')
  else
    call camelcasemotion#Motion('b', 1, 'n')
    normal! v
    call camelcasemotion#Motion(a:direction, a:count, 'iv')
  endif
  if &foldopen =~# 'hor\|all'
    normal! zv
  endif
endfunction


function! camelcasemotion#CreateMotionMappings(leader)
  " Create mappings according to this template:
  " (* stands for the mode [nov], ? for the underlying motion [wbe].)
  for l:mode in ['n', 'o', 'v']
    for l:motion in ['w', 'b', 'e', 'ge']
      let l:targetMapping = '<Plug>CamelCaseMotion_' . l:motion
      execute (l:mode ==# 'v' ? 'x' : l:mode) .
            \ 'map <silent> ' . a:leader . l:motion . ' ' . l:targetMapping
    endfor
  endfor

  " Create mappings according to this template:
  " (* stands for the mode [ov], ? for the underlying motion [wbe].)
  for l:mode in ['o', 'v']
    for l:motion in ['w', 'b', 'e', 'ge']
      let l:targetMapping = '<Plug>CamelCaseMotion_i' . l:motion
      execute (l:mode ==# 'v' ? 'x' : l:mode) .
            \ 'map <silent> i' . a:leader . l:motion . ' ' . l:targetMapping
    endfor
  endfor
  if &foldopen =~# 'hor\|all'
    normal! zv
  endif
endfunction

" vim: set sts=2 sw=2 expandtab ff=unix fdm=syntax :
