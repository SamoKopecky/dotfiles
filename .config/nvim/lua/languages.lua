-- Every language in one place. Each section may define:
--   ft          filetypes that formatters/linters apply to (default: the section name)
--   parsers     treesitter parsers to install
--   lsp         server name -> vim.lsp.config table (or a function returning one);
--               only servers listed here are installed and enabled
--   formatters  conform formatters, run in order
--   linters     nvim-lint linters
--   mason       Mason packages for the formatters/linters (LSP servers install themselves)
--
-- Read by plugins/treesitter.lua, plugins/lsp/config.lua, plugins/tools/conform.lua
-- and plugins/tools/lint.lua through the helpers at the bottom.

local languages = {
  lua = {
    parsers = { 'lua', 'luadoc' },
    lsp = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
          },
        },
      },
    },
    formatters = { 'stylua' },
    mason = { 'stylua' },
  },

  python = {
    parsers = { 'python' },
    lsp = {
      -- picks up <root>/.venv on its own
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = { typeCheckingMode = 'basic' },
          },
        },
        -- disable semantic tokens so treesitter handles highlighting
        on_attach = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      },
      ruff = {},
    },
    formatters = { 'ruff_format', 'ruff_fix', 'ruff_organize_imports' },
    mason = { 'ruff' },
  },

  rust = {
    parsers = { 'rust' },
    lsp = { rust_analyzer = {} },
    formatters = { 'rustfmt' }, -- from the rust toolchain, not Mason
  },

  go = {
    parsers = { 'go' },
    lsp = { gopls = {} },
  },

  -- JS/TS/Vue. Vue hybrid mode: ts_ls handles TS/JS + <script> in .vue via
  -- @vue/typescript-plugin, vue_ls handles template/CSS
  web = {
    ft = { 'javascript', 'typescript', 'vue' },
    parsers = { 'javascript', 'typescript', 'tsx', 'vue' },
    lsp = {
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
        -- formatting is done by eslint_d via conform
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },
    },
    formatters = { 'prettier', 'eslint_d' },
    mason = { 'prettier', 'eslint_d' },
  },

  html = {
    parsers = { 'html' },
  },

  css = {
    parsers = { 'css' },
    lsp = { cssls = {} },
  },

  json = {
    parsers = { 'json' },
    formatters = { 'jq' },
    mason = { 'jq' },
  },

  yaml = {
    parsers = { 'yaml' },
  },

  toml = {
    parsers = { 'toml' },
  },

  sql = {
    parsers = { 'sql' },
    formatters = { 'sql_formatter' },
    mason = { 'sql-formatter' },
  },

  sh = {
    parsers = { 'bash' },
    lsp = { bashls = {} },
    formatters = { 'shfmt' },
    mason = { 'shfmt' },
  },

  docker = {
    lsp = { dockerls = {} },
  },

  markdown = {
    parsers = { 'markdown', 'markdown_inline' },
    formatters = { 'markdownlint' },
    linters = { 'markdownlint' },
    mason = { 'markdownlint' },
  },

  -- parsers nvim itself uses (help, :checkhealth, queries, diffs)
  nvim = {
    parsers = { 'c', 'diff', 'query', 'vim', 'vimdoc' },
  },
}

-- [[ Helpers ]]
local M = { languages = languages }

local function each(fn)
  local names = vim.tbl_keys(languages)
  table.sort(names)
  for _, name in ipairs(names) do
    fn(name, languages[name])
  end
end

local function unique(list)
  local seen, out = {}, {}
  for _, v in ipairs(list) do
    if not seen[v] then
      seen[v] = true
      table.insert(out, v)
    end
  end
  return out
end

--- Treesitter parsers of all languages
function M.parsers()
  local out = {}
  each(function(_, l)
    vim.list_extend(out, l.parsers or {})
  end)
  return unique(out)
end

--- LSP server name -> config (functions resolved)
function M.servers()
  local out = {}
  each(function(name, l)
    for server, cfg in pairs(l.lsp or {}) do
      assert(out[server] == nil, ('languages.lua: LSP server %s defined twice (in %s)'):format(server, name))
      out[server] = type(cfg) == 'function' and cfg() or cfg
    end
  end)
  return out
end

--- Mason packages for formatters/linters
function M.mason_tools()
  local out = {}
  each(function(_, l)
    vim.list_extend(out, l.mason or {})
  end)
  return unique(out)
end

--- filetype -> list, for a per-language field (formatters/linters)
local function by_ft(field)
  local out = {}
  each(function(name, l)
    if l[field] then
      for _, ft in ipairs(l.ft or { name }) do
        assert(out[ft] == nil, ('languages.lua: %s for filetype %s defined twice (in %s)'):format(field, ft, name))
        out[ft] = l[field]
      end
    end
  end)
  return out
end

function M.formatters_by_ft()
  return by_ft 'formatters'
end

function M.linters_by_ft()
  return by_ft 'linters'
end

return M
