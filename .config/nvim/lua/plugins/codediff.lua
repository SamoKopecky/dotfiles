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

-- Remote default branch of the current file's repo (what a PR diffs against),
-- falling back to origin/main, origin/master, then local main/master
local function default_branch()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = file ~= '' and vim.fs.dirname(file) or vim.fn.getcwd()
  local function git(...)
    local out = vim.fn.systemlist { 'git', '-C', dir, ... }
    return vim.v.shell_error == 0 and out[1] or nil
  end
  local head = git('symbolic-ref', '--quiet', '--short', 'refs/remotes/origin/HEAD')
  if head then
    return head
  end
  for _, ref in ipairs { 'origin/main', 'origin/master', 'main', 'master' } do
    if git('rev-parse', '--verify', '--quiet', ref) then
      return ref
    end
  end
end

return {
  {
    'esmuellert/codediff.nvim',
    cmd = 'CodeDiff',
    keys = {
      { '<leader>gd', '<cmd>CodeDiff<cr>', desc = 'Git [d]iff working tree' },
      { '<leader>gs', '<cmd>CodeDiff --staged<cr>', desc = 'Git diff [s]taged' },
      {
        '<leader>gb',
        function()
          local base = default_branch()
          if not base then
            vim.notify('codediff: no default branch found (origin/HEAD, main, master)', vim.log.levels.WARN)
            return
          end
          vim.cmd('CodeDiff ' .. base .. '...')
        end,
        desc = 'Git diff [b]ranch vs default branch',
      },
      { '<leader>gh', '<cmd>CodeDiff history<cr>', desc = 'Git [h]istory' },
      { '<leader>gf', '<cmd>CodeDiff history %<cr>', desc = 'Git history of [f]ile' },
    },
    opts = {
      keymaps = {
        history = { fold_close_all = false },
      },
      explorer = {
        -- folders instead of a flat list; single-child chains flatten
        view_mode = 'tree',
        -- +added -removed per file and per group
        line_stats = { enabled = true },
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
