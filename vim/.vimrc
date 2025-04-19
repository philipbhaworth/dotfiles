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
set clipboard=unnamedplus

" ==================================================
"                 Plugin Management
" ==================================================

" Begin vim-plug configuration
"call plug#begin('~/.vim/plugged')

" List of plugins goes here
"Plug 'vim-airline/vim-airline'        " Status line plugin
"Plug 'vim-airline/vim-airline-themes' " Optional: Themes for vim-airline
"Plug 'sheerun/vim-polyglot'           " Language pack for syntax highlighting

" You can add more plugins here using the Plug command
" Example:
" Plug 'tpope/vim-fugitive'

" Initialize plugin system
"call plug#end()
" End vim-plug configuration

" ==================================================
"               Plugin-Specific Settings
" ==================================================

" Configure vim-airline
"let g:airline_powerline_fonts = 1          " Enable Powerline fonts
"let g:airline_theme = 'dark'               " Set the theme (optional)
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#formatter = 'unique_tail'

" Optional: Additional vim-airline settings can be added here

