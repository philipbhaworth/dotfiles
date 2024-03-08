" ==================================================
"                     .vimrc
" Personal Vim Configuration - Enhance Your Editing
" ==================================================

" Enable syntax highlighting
syntax on

" Show line numbers
set number

" Set tabs to have 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Enable filetype plugins
filetype plugin on
filetype indent on


" For Markdown editing
autocmd FileType markdown setlocal wrap
" autocmd FileType markdown setlocal spell spelllang=en_us
