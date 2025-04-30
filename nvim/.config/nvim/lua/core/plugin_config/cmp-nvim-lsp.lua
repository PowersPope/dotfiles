require'cmp'.setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- An example for configuring `clangd` LSP to use nvim-cmp as a completion engine
require('lspconfig').clangd.setup {
  capabilities = capabilities,
}
require('lspconfig')["basedpyright"].setup {
  capabilities = capabilities,
}
require('lspconfig')["lua_ls"].setup {
  capabilities = capabilities,
}
require('lspconfig')["ruff"].setup {
  capabilities = capabilities,
}
