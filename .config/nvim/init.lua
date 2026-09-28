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
vim.keymap.set('n', '<leader>b', ':b#<CR>', { desc = 'Previous [b]uffer' })
vim.keymap.set('n', '<leader>Q', '<cmd>qa<CR>', { desc = '[Q]uit all' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>t', '<Cmd>Neotree toggle<CR>', { silent = true, desc = 'Toggle Neo-[T]ree' })
-- <C-h/j/k/l> window navigation comes from vim-tmux-navigator

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
