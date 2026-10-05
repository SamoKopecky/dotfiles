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
      {
        '<leader>gB',
        function()
          -- Stacked PRs: diff against the parent branch instead of main
          vim.ui.input({ prompt = 'Base branch: ', completion = 'customlist,v:lua.CodeDiffBranches' }, function(base)
            if base and base ~= '' then
              vim.cmd('CodeDiff ' .. base .. '...')
            end
          end)
        end,
        desc = 'Git diff [B]ranch vs chosen base',
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
      -- Branch completion for the <leader>gB prompt
      _G.CodeDiffBranches = function(lead)
        return vim.tbl_filter(function(b)
          return vim.startswith(b, lead)
        end, vim.fn.systemlist { 'git', 'for-each-ref', '--format=%(refname:short)', 'refs/heads', 'refs/remotes' })
      end

      -- Entry point for shell aliases: `nvim '+CodeDiffOpen branch'`.
      -- Modes: local (default), staged, branch, history; anything else is passed
      -- straight to :CodeDiff. Every :CodeDiff opens its own tab, so the empty
      -- tab nvim started with gets closed once the diff tab shows up
      vim.api.nvim_create_user_command('CodeDiffOpen', function(cmd)
        local mode = cmd.args ~= '' and cmd.args or 'local'
        local args
        if mode == 'local' then
          args = ''
        elseif mode == 'staged' then
          args = '--staged'
        elseif mode == 'branch' then
          local base = default_branch()
          if not base then
            vim.notify('codediff: no default branch found (origin/HEAD, main, master)', vim.log.levels.WARN)
            return
          end
          args = base .. '...'
        else
          args = mode
        end

        local start_tab = vim.api.nvim_get_current_tabpage()
        local start_buf = vim.api.nvim_get_current_buf()
        local start_empty = #vim.api.nvim_tabpage_list_wins(start_tab) == 1
          and vim.api.nvim_buf_get_name(start_buf) == ''
          and not vim.bo[start_buf].modified
          and vim.api.nvim_buf_line_count(start_buf) == 1
          and vim.api.nvim_buf_get_lines(start_buf, 0, 1, false)[1] == ''
        if start_empty then
          vim.api.nvim_create_autocmd('TabNewEntered', {
            once = true,
            callback = function()
              vim.schedule(function()
                if vim.api.nvim_tabpage_is_valid(start_tab) and #vim.api.nvim_list_tabpages() > 1 then
                  vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(start_tab))
                end
              end)
            end,
          })
        end

        vim.cmd('CodeDiff ' .. args)
      end, {
        nargs = '*',
        complete = function()
          return { 'local', 'staged', 'branch', 'history' }
        end,
        desc = 'Open a CodeDiff view, dropping the empty startup tab',
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'codediff-history',
        callback = function(args)
          vim.keymap.set('n', 'zM', collapse_all_commits, { buffer = args.buf, desc = 'Collapse all commits' })
        end,
      })
    end,
  },
}
