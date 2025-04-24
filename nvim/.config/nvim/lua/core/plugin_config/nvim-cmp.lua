-- https://github.com/wincent/wincent/blob/64947cd9efc70844ee6f1a1d44dd381a3ec6569a/aspects/nvim/files/.config/nvim/after/plugin/nvim-cmp.lua#L16
-- Large inspiration from this github repo

local has_cmp, cmp = pcall(require, 'cmp')

local select_next_item = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  else
    fallback()
  end
end

local select_prev_item = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end


-- MatchSuffix Completetion that is brought up in issue/1716
local confirm = function(entry)
  local behavior = cmp.ConfirmBehavior.Replace
  if entry then
    local completion_item = entry.completion_item
    local newText = ''
    if completion_item.textEdit then
      newText = completion_item.textEdit.newText
    elseif type(completion_item.insertText) == 'string' and completion_item.insertText ~= '' then
      newText = completion_item.insertText
    else
      newText = completion_item.word or completion_item.label or ''
    end

    -- How many characters will be different after the cursor position if we replace?
    local diff_after = math.max(0, entry.replace_range['end'].character + 1) - entry.context.cursor.col

    -- Does the text that will be replaced after the cursor match the suffix 
    -- of the `newText` to be inserted? if not, we should `Insert` instead.
    if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
      behavior = cmp.ConfirmBehavior.Insert
    end
  end
  cmp.confirm({ select = true, behavior = behavior })
end


cmp.setup({
  experimental = {
    -- See also `toggle_ghost_text()` below.
    ghost_text = true,
  },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

      -- For `mini.snippets` users:
      -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
      -- insert({ body = args.body }) -- Insert at cursor
      -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
      -- require("cmp.config").set_onetime({ sources = {} })
    end,
  },
  

--   formatting = {
--     -- See: https://github.com/hrsh6th/nvim-cmp/wiki/Menu-Appearance
--     format = function(entry, vim_item)
--       -- Set `kind` to "$icon $kind".
--       vim_item.kind = string.format('%s %s', lsp_kinds[vim_item.kind], vim_item.kind)
--       vim_item.menu = ({
--         buffer = '[Buffer]',
--         nvim_lsp = '[LSP]',
--         luasnip = '[LuaSnip]',
--         nvim_lua = '[Lua]',
--         latex_symbols = '[LaTeX]',
--       })[entry.source.name]
--       return vim_item
--     end,
--   },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  }),

  mapping = {
    -- Scroll up and down on the docs that pop up
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.close()
      elseif has_luasnip and luasnip.choice_active() then
        luasnip.jump(1)
      else 
        fallback()
      end
    end, { 'i', 's' }),

    -- Mappings for moving up and down the autocompete tabs
    ['<C-j>'] = cmp.mapping(select_next_item),
    ['<C-k>'] = cmp.mapping(select_prev_item),

    -- Confirm the selection 
    ['<C-y>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        confirm(entry)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },

  window = {
    completion = cmp.config.window.bordered({
      border = 'single',
      col_offset = -1,
      scrollbar = false,
      scrolloff = 3,
      -- Default for bordered() is 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None'
      -- Default for non-bordered, which we'll use here, is:
      winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
    }),
    documentation = cmp.config.window.bordered({
      border = 'solid',
      scrollbar = false,
      -- Default for bordered() is 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None'
      -- Default for non-bordered is 'FloatBorder:NormalFloat'
      -- Suggestion from: https://github.com/hrsh7th/nvim-cmp/issues/2042
      -- is to use 'NormalFloat:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None'
      -- but this also seems to suffice:
      winhighlight = 'CursorLine:Visual,Search:None',
    }),
  },
})


-- Only show ghost text at word boundaries, not inside keywords.

local config = require('cmp.config')

local toggle_ghost_text = function()
  if vim.api.nvim_get_mode().mode ~= 'i' then
    return
  end

  local cursor_column = vim.fn.col('.')
  local current_line_contents = vim.fn.getline('.')
  local character_after_curosr = current_line_contents:sub(cursor_column, cursor_column)

  local should_enable_ghost_text = character_after_curosr == '' or vim.fn.match(character_after_curosr, [[\k]]) == -1

  local current = config.get().experimental.ghost_text
  if current ~= should_enable_ghost_text then
    config.set_global({
      experimental = { should_enable_ghost_text, },
    })
  end
end

vim.api.nvim_create_autocmd({ 'InsertEnter', 'CursorMovedI' }, {
  callback = toggle_ghost_text,
})
