-- Specific key mappings
vim.g.mapleader = ' '
vim.g.maplocalloader = ' '

-- Specify that relative line numbers be pesent in our files
vim.opt.number = true
vim.wo.relativenumber = true

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Remap of commands
-- Unhiglight searched text
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
