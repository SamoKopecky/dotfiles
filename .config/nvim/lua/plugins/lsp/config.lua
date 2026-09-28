return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Install LSPs and tools into stdpath
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- LSP progress messages
    { 'j-hui/fidget.nvim', opts = {} },

    -- Completion capabilities from nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        local builtin = require 'telescope.builtin'

        -- K (hover) and <C-s> (signature help) are nvim defaults
        map('gd', builtin.lsp_definitions, '[G]oto [D]efinition') -- back with <C-t>
        map('grr', builtin.lsp_references, '[G]oto [R]eferences')
        map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('<leader>k', vim.lsp.buf.signature_help, 'Signature help')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Highlight references of the word under the cursor while it rests there
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>Th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    require('mason').setup()

    local servers = require 'plugins.lsp.packages_lsp'
    local mason_packages = require 'plugins.lsp.packages'

    -- Non-LSP tools (formatters, linters)
    require('mason-tool-installer').setup { ensure_installed = mason_packages }

    -- Only servers listed in packages_lsp.lua get installed and enabled,
    -- even if Mason has others installed.
    local server_names = vim.tbl_keys(servers)
    require('mason-lspconfig').setup {
      ensure_installed = server_names,
      automatic_enable = server_names,
    }

    -- Shared capabilities for every server, then per-server overrides
    vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })
    for server_name, server in pairs(servers) do
      if type(server) == 'function' then
        server = server()
      end
      vim.lsp.config(server_name, server)
    end
  end,
}
