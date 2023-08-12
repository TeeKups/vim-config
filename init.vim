set nocompatible

" Filetype
"   on          When a new buffer is opened, vim will try to do its best to detect and
"               set the filetype
"   plugin      With this option, filetype-specific plugins will loaded  (if any)
filetype plugin on

" Enable syntax highlighting
syntax enable

" Use utf-8 encoding
set encoding=utf-8

"Use \n line endings
set fileformat=unix

" Tabstop ? characters long, softtabstop = n spaces long
set tabstop=4 softtabstop=4
set shiftwidth=4

" Convert tab to spaces
set expandtab

" Autoindent applies the indent of the current line to the next line
" while smartindent takes into account the syntax/style of the code/text being edited
" Autoundent and smartundent should be used together
set autoindent
set smartindent

" Show linenumbers
set number

" Do not wrap lines (it's annoying)
set nowrap

" Specify where a new split will be positioned
set splitbelow splitright

" Highlight unwanted characters
"   tab                 >
"   trailing spaces     ·
set listchars=tab:>\ ,nbsp:·,trail:·
set list

" Case insensitive search
set smartcase

" Disable mouse clicks, scrolling moves cursor
set mouse=

" Do not create swap files
set noswapfile

" While typing a search command, show where the pattern, as it was typed
" so far, matches. The matched string is highlighted.
set incsearch

" Oh dear god I hope my computer won't crash... Just safe frequently lmao
set nobackup

" Set line width. 149 characters fits nicely into half of my main monitor.
set textwidth=149

" Disable bells ringing in my ears
set noerrorbells

" Yanking also puts stuff into clipboard
set clipboard+=unnamedplus

" When pressing *, Highlight all occurrences of current word but do not jump
nnoremap * :let @/ = '\<'.expand('<cword>').'\>' \| set hlsearch<C-M>

" fix for lazy shift-pinkie when writing or closing
cabbrev <expr> W getcmdtype() == ":" && getcmdline() == 'W' ? 'w' : 'W'
cabbrev <expr> Q getcmdtype() == ":" && getcmdline() == 'Q' ? 'q' : 'Q'
cabbrev <expr> Wqa getcmdtype() == ":" && getcmdline() == 'Wqa' ? 'wqa' : 'Wqa'
cabbrev <expr> Qa getcmdtype() == ":" && getcmdline() == 'Qa' ? 'qa' : 'qa'
cabbrev <expr> Wq getcmdtype() == ":" && getcmdline() == 'Wq' ? 'wq' : 'Wq'

" When multiple tabs are open, only close current tab instead of closing vim
cabbrev <expr> wqa getcmdtype() == ":" && getcmdline() == 'wqa' && tabpagenr('$') > 1 ? 'wa \| tabclose' : 'wqa'
cabbrev <expr> qa getcmdtype() == ":" && getcmdline() == 'qa' && tabpagenr('$') > 1 ? 'tabclose' : 'qa'

" Use camelcasemotion movements in w, b, and e
map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
source $HOME/.config/nvim/camelcasemotion.vim

" camelCaseWord snake_case_word
