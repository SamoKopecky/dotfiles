-- File tree, toggled with <leader>t

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    window = {
      width = 30,
    },
    filesystem = {
      -- `nvim .` opens tree as sidebar instead of taking over the main window,
      -- so pickers (telescope grep) open files there and keep the jump position
      hijack_netrw_behavior = 'open_default',
    },
  },
}
