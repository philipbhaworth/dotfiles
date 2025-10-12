" ==================================================
"                     .vimrc
" Personal Vim Configuration - Enhance Your Editing
" ==================================================

" Core functionality
set nocompatible
syntax on
set encoding=utf-8
filetype plugin indent on

" ==================================================
" Colorscheme
" ==================================================

" Enable 256 colors if available
if &t_Co >= 256 || has("gui_running")
  set t_Co=256
endif

" Use a built-in colorscheme (works everywhere)
silent! colorscheme desert
" Alternatives: slate, ron, pablo, koehler, elflord, darkblue

" Fallback if colorscheme fails
if !exists('g:colors_name')
  colorscheme default
endif

" ==================================================
" General Settings
" ==================================================

" Line numbers
set number

" Indentation defaults (4-space)
set tabstop=4       " Number of spaces tabs count for
set shiftwidth=4    " Number of spaces to use for each step of (auto)indent
set softtabstop=4   " Number of spaces for Tab key in insert mode
set expandtab       " Use spaces instead of tabs
set autoindent      " Copy indent from current line when starting a new line
set smartindent     " Smart indenting on new lines
set shiftround      " Round indent to multiple of shiftwidth

" Backspace behavior
set backspace=indent,eol,start

" ==================================================
" Search Settings
" ==================================================

set incsearch       " Incremental search (search as you type)
set hlsearch        " Highlight search results
set ignorecase      " Ignore case when searching
set smartcase       " Override ignorecase if search has uppercase
set showmatch       " Show matching parentheses/brackets

" ==================================================
" UI Settings
" ==================================================

set wrap            " Enable line wrapping
set laststatus=2    " Always show status line
set wildmenu        " Better command-line completion
set mouse=a         " Enable mouse support

" ==================================================
" File Settings
" ==================================================

set nobackup        " Disable backup files
set noswapfile      " Disable swap files

" ==================================================
" File Type Specific Settings
" ==================================================

autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2 autoindent
autocmd FileType json setlocal expandtab tabstop=2 shiftwidth=2 autoindent
autocmd FileType toml setlocal expandtab tabstop=2 shiftwidth=2 autoindent
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 autoindent
autocmd FileType sh setlocal expandtab tabstop=4 shiftwidth=4 autoindent
autocmd FileType markdown setlocal wrap linebreak
autocmd FileType make setlocal noexpandtab tabstop=8 shiftwidth=8

" Optional: Enable spell check for markdown
" autocmd FileType markdown setlocal spell spelllang=en_us
