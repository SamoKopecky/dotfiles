-- return {
--   'AlexvZyl/nordic.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require('nordic').load()
--   end,
-- }

return {
  'HoNamDuong/hybrid.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    overrides = function(hl, c)
      local red = '#ff0000'
      -- hl.Type = {
      --   fg = red,
      -- }
    end,
  },
  config = function(_, opts)
    require('hybrid').setup(opts)
    vim.cmd.colorscheme 'hybrid'
  end,
}
