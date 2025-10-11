" ==================================================
"                     .vimrc
" Personal Vim Configuration - Enhance Your Editing
" ==================================================

" Enable syntax highlighting
syntax on

" Set line numbers
set number

" File type specific settings
autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2 autoindent
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 autoindent
autocmd FileType sh setlocal expandtab tabstop=4 shiftwidth=4 autoindent
autocmd FileType markdown setlocal wrap
" autocmd FileType markdown setlocal spell spelllang=en_us

" General settings
set tabstop=4       " Number of spaces tabs count for
set shiftwidth=4    " Number of spaces to use for each step of (auto)indent
set expandtab       " Use spaces instead of tabs
set autoindent      " Copy indent from current line when starting a new line
set smartindent     " Smart indenting on new lines

" Enable incremental search
set incsearch

" Highlight search results
set hlsearch

" Show matching parentheses
set showmatch

" Enable line wrapping
set wrap

" Set default encoding to UTF-8
set encoding=utf-8

" Disable backup files
set nobackup
set noswapfile

" Enable mouse support
set mouse=a

" Better command-line completion
set wildmenu

" Set clipboard to use system clipboard
" set clipboard=unnamedplus

" ==================================================
" Statusline: minimal, readable, fast (no plugins, no git)
" ==================================================

" Always show a statusline (even with one window)
set laststatus=2

" If your terminal supports truecolor, enable it (safe fallback to 256c)
if has('termguicolors')
  set termguicolors
endif

" Colors for active/inactive statuslines (GUI + 256-color fallback)
" Tweak to taste for your dark theme.
highlight StatusLine   ctermfg=15  ctermbg=18  cterm=NONE  guifg=#FFFFFF guibg=#1f2a44 gui=NONE
highlight StatusLineNC ctermfg=8   ctermbg=0   cterm=NONE  guifg=#808080 guibg=#000000 gui=NONE

" Optional: if your font doesn't render '☰', set this to an empty string.
let g:sl_icon = '☰'

" Mode label (fast: no external calls)
function! ModeStatus()
  let m = mode()
  return m ==# 'n' ? 'NORMAL' :
        \ m ==# 'i' ? 'INSERT' :
        \ m ==# 'v' ? 'VISUAL' :
        \ m ==# 'V' ? 'V-LINE' :
        \ m ==# "\<C-v>" ? 'V-BLOCK' :
        \ m ==# 'R' ? 'REPLACE' : m
endfunction

" Build the statusline
" Left  : icon + mode + truncated path + flags
" Right : filetype | format | encoding | line:col | percent
set statusline=
set statusline+=%#StatusLine#
set statusline+=%{exists('g:sl_icon')?g:sl_icon:''}\ %{ModeStatus()}\ 
set statusline+=%<%f\ %m%r%h%w
set statusline+=%=
set statusline+=%y\                                 " filetype
set statusline+=\ [%{&fileformat}]                  " unix/dos/mac
set statusline+=\ [%{&fileencoding?&fileencoding:&encoding}]
set statusline+=\ %l:%c\ %p%%

" == Optional tweaks ========================================
" 1) Show only the filename (no directories):
"    Replace %f above with %t (or uncomment the two lines below):
" set statusline=
" set statusline+=%#StatusLine#%{exists('g:sl_icon')?g:sl_icon.'' : ''}\ %{ModeStatus()}\ %<%t\ %m%r%h%w%=%y\ [%{&fileformat}]\ [%{&fileencoding?&fileencoding:&encoding}]\ %l:%c\ %p%%

" 2) Add a small clock (cheap, safe):
" set statusline+=\ %{strftime('%H:%M')}

" == Title bar (top) = optional ============================
set title
set titlestring=%{hostname()}\ -\ %f\ (%{&filetype})

