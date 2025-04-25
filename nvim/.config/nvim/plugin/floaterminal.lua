-- Custom Plugin that was generated following along to the video here:
-- https://www.youtube.com/watch?v=5PIiKDES_wc&t=374s
-- Skeleton was made from above, but will apply changes

vim.keymap.set("t", "<c-q><c-q>", "<c-\\><c-n>")

-- Local state variable to keep track of our window
local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

-- Floating Terminal Function
local function OpenFloatingTerminal(opts)
  opts = opts or {}
  -- Calculate 80% of the screen size
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  -- Center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a new scratch buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  })

  -- Output our opts
  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = OpenFloatingTerminal { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.term()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Function for creating our terminals
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})

-- Keymap for calling our floating terminal function
vim.keymap.set({"n", "t"}, "<leader>tt", toggle_terminal)

