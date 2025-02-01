return {
  lua = { 'stylua' },
  -- Conform can also run multiple formatters sequentially
  python = { 'ruff', 'black' },
  rust = { 'rust_analyzer' },
  markdown = { 'markdownlint' },
  typescript = { 'prettier' },
  javascript = { 'prettier' },
  vue = { 'prettier' },
  --
  -- You can use 'stop_after_first' to run the first available formatter from the list
  -- javascript = { "prettierd", "prettier", stop_after_first = true },
}
