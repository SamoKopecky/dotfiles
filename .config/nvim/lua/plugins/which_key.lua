return { -- Shows pending keybinds
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    icons = { mappings = true },

    -- Document existing key chains
    spec = {
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>T', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'x' } },
      { '<leader>g', group = '[G]it diff' },
    },
  },
}
