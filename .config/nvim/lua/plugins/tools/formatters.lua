return {
  lua = { 'stylua' },
  python = { 'ruff_format', 'ruff_fix', 'ruff_organize_imports' },
  rust = { 'rustfmt' },
  markdown = { 'markdownlint' },
  json = { 'jq' },
  javascript = { 'prettier', 'eslint_d' },
  typescript = { 'prettier', 'eslint_d' },
  vue = { 'prettier', 'eslint_d' },
  sql = { 'sql_formatter' },
  sh = { 'shfmt' },
}
