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
  -- Vue.js LSP Setup (Hybrid Mode - Latest Convention)
  -- ts_ls handles TypeScript/JavaScript + Vue files with Vue plugin
  -- vue_ls handles CSS/HTML in Vue files
  ts_ls = function()
    local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

    return {
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      init_options = {
        plugins = {
          {
            name = '@vue/typescript-plugin',
            location = vue_language_server_path,
            languages = { 'vue' },
          },
        },
      },
    }
  end,
  vue_ls = {},
  eslint = {
    -- Disable formatting (handled by eslint_d via conform)
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
  cssls = {},
  gopls = {},
  ruff = {},
}
