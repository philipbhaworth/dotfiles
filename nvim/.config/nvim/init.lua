-- Set leader key first
vim.g.mapleader = ' '

-- Your existing settings converted to lua
vim.o.number = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.showmatch = true
vim.o.backspace = 'indent,eol,start'
vim.o.wrap = true
vim.o.hidden = true
vim.o.wildmenu = true
vim.o.mouse = 'a'

-- Search settings
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- File settings
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Status line
vim.o.laststatus = 2

-- Colorscheme
vim.o.background = 'dark'
local ok_theme = pcall(vim.cmd.colorscheme, 'retrobox')
if not ok_theme then
  vim.cmd.colorscheme('default')
end

vim.cmd('syntax on')

-- Keymaps
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>quitall<cr>')
vim.keymap.set({'n', 'x'}, 'gy', '"+y')
vim.keymap.set({'n', 'x'}, 'gp', '"+p')
vim.keymap.set('n', '<C-L>', ':nohlsearch<CR><C-L>')

-- Filetype-specific settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'yaml', 'json', 'toml'},
  command = 'setlocal expandtab tabstop=2 shiftwidth=2'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'python', 'sh'},
  command = 'setlocal expandtab tabstop=4 shiftwidth=4'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'puppet',
  command = 'setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  command = 'setlocal wrap linebreak'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'make',
  command = 'setlocal noexpandtab tabstop=8 shiftwidth=8'
})
