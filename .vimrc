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

" Color scheme (optional, you can choose one you like)

" Better command-line completion
set wildmenu

" Set clipboard to use system clipboard
set clipboard=unnamedplus
