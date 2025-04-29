-- Specific key mappings
vim.g.mapleader = ' '
vim.g.maplocalloader = ' '

-- Specify the path for python
vim.g.python3_host_prog = '$HOME/miniconda3/bin/python'

-- Specify that relative line numbers be pesent in our files
vim.opt.number = true
vim.wo.relativenumber = true

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- Set our conceallevl for concealing characters
vim.opt.conceallevel = 1

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Remap of commands
-- Unhiglight searched text
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- Set up commenting out. This is custom and from here:
-- https://slar.se/comment-and-uncomment-code-in-neovim.html
local non_c_line_comments_by_filetype = {
  lua = "-- ",
  python = "# ",
  xml = "<--",
}

local function comment_out(opts)
  local line_comment = non_c_line_comments_by_filetype[vim.bo.filetype] or "// "
  local start = math.min(opts.line1, opts.line2)
  local finish = math.max(opts.line1, opts.line2)
  vim.api.nvim_command(start .. "," .. finish .. "s:^:" .. line_comment .. ":")
  vim.api.nvim_command("noh")
end

local function uncomment(opts)
  local line_comment = non_c_line_comments_by_filetype[vim.bo.filetype] or "// "
  local start = math.min(opts.line1, opts.line2)
  local finish = math.max(opts.line1, opts.line2)

  pcall(vim.api.nvim_command, start .. "," .. finish .. "s:^\\(\\s\\{-\\}\\)" .. line_comment .. ":\\1:")
  vim.api.nvim_command("noh")
end

-- Set comment/uncomment keybinds
vim.api.nvim_create_user_command("CommentOut", comment_out, { range = true })
vim.keymap.set('v', '<leader>/', ':CommentOut<CR>')
vim.keymap.set('n', '<leader>/', ':CommentOut<CR>')

vim.api.nvim_create_user_command("Uncomment", uncomment, { range = true })
vim.keymap.set('v', '<leader>uc', ':Uncomment<CR>')
vim.keymap.set('n', '<leader>uc', ':Uncomment<CR>')

-- Custom Keymap for saving and sourcing a file
vim.keymap.set('n', '<leader>s', ':w | source %<CR>', { desc = "Save and source file"})

