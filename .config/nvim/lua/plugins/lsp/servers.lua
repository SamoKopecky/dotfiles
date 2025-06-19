-- local mason_registry = require 'mason-registry'
-- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'

return {
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = 'basic',
        },
      },
    },
  },
  rust_analyzer = {},
  lua_ls = {
    -- cmd = {... },
    -- filetypes = { ... },
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
  prettier = {},
  volar = {
    filetypes = { 'vue' },
    init_options = {
      vue = {
        hybridMode = false,
      },
    },
  },
  -- vue_ls = { filetypes = { 'test' } },

  -- volar = { filetypes = { 'vue' } },
  ts_ls = {
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  },
  eslint = {},
  cssls = {},
  gopls = {},
}
