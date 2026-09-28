-- VSCode style diff review workspace, handy for reviewing AI agent changes

-- Built-in zM only collapses the commit under cursor, this collapses every commit
local function collapse_all_commits()
  local panel = require('codediff.ui.lifecycle').get_panel(vim.api.nvim_get_current_tabpage())
  local tree = panel and panel.view and panel.view.tree
  if not tree then
    return
  end
  for _, commit in ipairs(tree:get_nodes()) do
    commit:collapse()
  end
  tree:render()
end

return {
  {
    'esmuellert/codediff.nvim',
    cmd = 'CodeDiff',
    keys = {
      { '<leader>gd', '<cmd>CodeDiff<cr>', desc = 'Git [d]iff working tree' },
      { '<leader>gs', '<cmd>CodeDiff --staged<cr>', desc = 'Git diff [s]taged' },
      { '<leader>gb', '<cmd>CodeDiff main...<cr>', desc = 'Git diff [b]ranch vs main' },
      { '<leader>gh', '<cmd>CodeDiff history<cr>', desc = 'Git [h]istory' },
      { '<leader>gf', '<cmd>CodeDiff history %<cr>', desc = 'Git history of [f]ile' },
    },
    opts = {
      keymaps = {
        history = { fold_close_all = false },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'codediff-history',
        callback = function(args)
          vim.keymap.set('n', 'zM', collapse_all_commits, { buffer = args.buf, desc = 'Collapse all commits' })
        end,
      })
    end,
  },
}
