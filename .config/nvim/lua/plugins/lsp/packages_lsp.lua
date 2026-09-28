return {
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = 'basic',
        },
      },
    },
    -- disable semantic tokens so treesitter handles highlighting
    on_attach = function(client)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  },
  rust_analyzer = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  },
  -- Vue hybrid mode: ts_ls handles TS/JS + <script> in .vue via @vue/typescript-plugin,
  -- vue_ls handles template/CSS
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
  bashls = {},
  dockerls = {},
}
