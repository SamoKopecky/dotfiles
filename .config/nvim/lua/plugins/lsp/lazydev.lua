return {
  -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      -- Load luv (libuv) types when `vim.uv` is used
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
