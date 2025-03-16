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
    filetypes = { 'vue', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    init_options = { vue = { hybridMode = false } },
  },
  -- volar = { filetypes = { 'vue' } },
  -- ts_ls = {
  --   filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  -- },
  --   init_options = {
  --     plugins = {
  --       {
  --         name = '@vue/typescript-plugin',
  --         location = 'install pacakge inside project',
  --         languages = { 'vue', 'javascript', 'typescript' },
  --       },
  --     },
  --   },
  -- },
  eslint = {},
  cssls = {},
  gopls = {},
}
