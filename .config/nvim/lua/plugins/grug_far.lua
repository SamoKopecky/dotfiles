-- Project-wide search and replace
return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  opts = {},
  keys = {
    {
      '<leader>S',
      function()
        require('grug-far').open()
      end,
      desc = '[S]earch and replace (grug-far)',
    },
    {
      '<leader>sW',
      function()
        require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } }
      end,
      desc = '[S]earch and replace current [W]ord',
    },
    {
      '<leader>sW',
      function()
        require('grug-far').with_visual_selection()
      end,
      mode = 'x',
      desc = '[S]earch and replace selection',
    },
  },
}
