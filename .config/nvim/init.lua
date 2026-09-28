-- Leader must be set before plugins load
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- [[ Options ]]  see `:help option-list`
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.swapfile = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false -- shown in lualine
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true -- case-insensitive search unless \C or a capital letter
vim.o.smartcase = trua
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split' -- live preview of :s
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.foldlevel = 99 -- open files unfolded (folds come from treesitter, see plugins/treesitter.lua)

-- Sync with the OS clipboard; scheduled because it can slow down startup
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- [[ Keymaps ]]
vim.keymap.set('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
vim.keymap.set('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste and delete into null buffer' })
vim.keymap.set('n', '<leader>Q', '<cmd>qa<CR>', { desc = '[Q]uit all' })
-- Jumplist / changelist as bracket pairs ([ = back, ] = forward)
vim.keymap.set('n', '[g', '<C-o>', { desc = 'Older jump ([g]o back)' })
vim.keymap.set('n', ']g', '<C-i>', { desc = 'Newer jump ([g]o forward)' })
vim.keymap.set('n', '[e', 'g;', { desc = 'Older [e]dit' })
vim.keymap.set('n', ']e', 'g,', { desc = 'Newer [e]dit' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>t', '<Cmd>Neotree toggle<CR>', { silent = true, desc = 'Toggle Neo-[T]ree' })
-- <C-h/j/k/l> window navigation comes from vim-tmux-navigator

-- Copy `path:line` (visual: `path:start-end`) relative to the repo root,
-- e.g. to point Claude at code
vim.keymap.set({ 'n', 'x' }, '<leader>yr', function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' or vim.bo.buftype ~= '' then
    vim.notify('Not a file buffer', vim.log.levels.WARN)
    return
  end
  local root = vim.fs.root(0, '.git') or vim.fn.getcwd()
  local path = vim.fs.relpath(root, file) or vim.fn.fnamemodify(file, ':.')
  local first, last = vim.fn.line 'v', vim.fn.line '.'
  if first > last then
    first, last = last, first
  end
  local ref = first == last and ('%s:%d'):format(path, last) or ('%s:%d-%d'):format(path, first, last)
  vim.fn.setreg('+', ref)
  if vim.fn.mode():match '[vV\22]' then
    vim.api.nvim_feedkeys(vim.keycode '<Esc>', 'nx', false)
  end
  vim.notify('Copied ' .. ref)
end, { desc = '[Y]ank code [r]eference (path:line)' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Diagnostics: show the float after every jump (<leader>nd/pd, ]d/[d)
vim.diagnostic.config {
  jump = {
    on_jump = function(diagnostic, bufnr)
      if diagnostic then
        vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
      end
    end,
  },
}
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror msg' })
vim.keymap.set('n', '<leader>nd', function()
  vim.diagnostic.jump { count = 1 }
end, { desc = 'Jump [N]ext [D]iagnostic' })
vim.keymap.set('n', '<leader>pd', function()
  vim.diagnostic.jump { count = -1 }
end, { desc = 'Jump [P]revious [D]iagnostic' })

-- [[ Autocommands ]]
-- Reload buffers changed on disk by other programs (e.g. Claude in another pane).
-- Buffers with unsaved changes are never overwritten; nvim asks instead.
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('auto-reload', { clear = true }),
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = 'auto-reload',
  callback = function(args)
    vim.notify('Reloaded ' .. vim.fn.fnamemodify(args.file, ':.') .. ' (changed on disk)')
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ lazy.nvim ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  require 'plugins.treesitter',
  require 'plugins.autopairs',
  require 'plugins.neo-tree',
  require 'plugins.vim_tmux_navigator',
  require 'plugins.gitsigns',
  require 'plugins.codediff',
  require 'plugins.which_key',
  require 'plugins.telescope',
  require 'plugins.theme',
  require 'plugins.lualine',
  require 'plugins.indent_line',
  require 'plugins.grug_far',

  require 'plugins.lsp.lazydev',
  require 'plugins.lsp.config',

  require 'plugins.tools.conform',
  require 'plugins.tools.lint',

  require 'plugins.nvim_cmp',
  require 'plugins.lsp_file_operations',
  require 'plugins.autotag',
  require 'plugins.colorizer',
  require 'plugins.todo_comments',
  require 'plugins.mini',
}, {
  rocks = { enabled = false },
})

-- vim: ts=2 sts=2 sw=2 et
