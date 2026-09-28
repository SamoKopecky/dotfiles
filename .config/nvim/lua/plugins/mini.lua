return {
  'nvim-mini/mini.nvim',
  config = function()
    -- Around/inside textobjects, e.g. va) yinq ci'
    require('mini.ai').setup { n_lines = 500 }
    -- Surround: saiw) add, sd' delete, sr)' replace
    require('mini.surround').setup()
  end,
}
