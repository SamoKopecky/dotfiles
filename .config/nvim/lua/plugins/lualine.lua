return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local custom_theme = require('lualine.themes.auto')
    custom_theme.normal.a = { bg = '#61afef', fg = '#282c34', gui = 'bold' }
    custom_theme.insert.a = { bg = '#98c379', fg = '#282c34', gui = 'bold' }
    custom_theme.visual.a = { bg = '#c678dd', fg = '#282c34', gui = 'bold' }
    custom_theme.replace.a = { bg = '#e06c75', fg = '#282c34', gui = 'bold' }
    custom_theme.command.a = { bg = '#e5c07b', fg = '#282c34', gui = 'bold' }

    require('lualine').setup {
      options = {
        theme = custom_theme,
        section_separators = '',
        component_separators = '',
      },
      sections = {
        lualine_c = { { 'filename', path = 1 } },
      },
    }
  end,
}
