return {
  'nickkadutskyi/jb.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = 'dark'
    vim.cmd.colorscheme 'jb'
    local dark_orange = '#AA4926'
    vim.api.nvim_set_hl(0, 'LanguageDefaults_Classes_InstanceField', { fg = dark_orange })
    vim.api.nvim_set_hl(0, 'LanguageDefaults_Classes_StaticField', { fg = dark_orange, italic = true })
    vim.api.nvim_set_hl(0, 'LanguageDefaults_Identifiers_Constant', { fg = dark_orange, italic = true })
    vim.api.nvim_set_hl(0, 'GenericLanguage_Keyword2', { fg = dark_orange })
  end,
}
