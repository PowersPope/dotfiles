require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "basedpyright", "clangd", "lua_ls", "ruff"}
}
