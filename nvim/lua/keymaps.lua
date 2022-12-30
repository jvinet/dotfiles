----------------------------------------------------------------------------
-- [[ Keymaps ]]
----------------------------------------------------------------------------

-- If I'm in Termux or some other hamstrung environment, I may not be able to
-- remap Capslock to Esc. This is an acceptable workaround.
vim.keymap.set('i', 'kj', '<esc>')

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Easy movement between windows
vim.keymap.set('n', '<C-j>' ,'<C-W>j', { noremap = true })
vim.keymap.set('n', '<C-k>' ,'<C-W>k', { noremap = true })
vim.keymap.set('n', '<C-h>' ,'<C-W>h', { noremap = true })
vim.keymap.set('n', '<C-l>' ,'<C-W>l', { noremap = true })

-- Easy tab control
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>')
vim.keymap.set('n', '<leader>to', ':tabonly<CR>')
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>')
vim.keymap.set('n', '<leader>tm', ':tabmove<CR>')
vim.keymap.set('n', '<leader>]', ':tabnext<CR>')
vim.keymap.set('n', '<leader>[', ':tabprev<CR>')

-- Stop highlighting search matches
vim.keymap.set('n', '<leader>q', ':nohlsearch<CR>')

-- Redraw visible area
vim.keymap.set('n', '<leader>r', ":redraw!<CR>")
-- Toggle visible tab characters
vim.keymap.set('n', '<leader>l', ":set list!<CR>")
-- Toggle line numbers
vim.keymap.set('n', '<leader>n', ":set number!<CR>")
-- Paste mode
vim.keymap.set('n', '<leader>p', ":setlocal paste!<CR>")

-- Close/open/clear the quickfix window
vim.keymap.set('n', '<leader>cw', ":cclose<CR>")
vim.keymap.set('n', '<leader>co', ":copen<CR>")
vim.keymap.set('n', '<leader>cc', ":call setqflist([])<CR>")

-- Close/open the location-list window
vim.keymap.set('n', '<leader>lw', ":lclose<CR>")
vim.keymap.set('n', '<leader>lw', ":lopen<CR>")

-- Switch 0 and ^
vim.keymap.set('n', '0', '_')
vim.keymap.set('n', '^', '999h')
vim.keymap.set('n', '<leader>0', '999h')

----------------------------------------------------------------------------
-- [[ Keymaps for Plugins ]]
----------------------------------------------------------------------------

-- UndoTree
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>')

-- NERDTree / nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>f', ':NvimTreeFocus<CR>')
--vim.keymap.set('n', '<leader>e', ':NERDTreeToggle<CR>')
--vim.keymap.set('n', '<leader>f', ':NERDTreeFocus<CR>')

-- I don't even know how to use Ex mode
vim.keymap.set('n', 'Q', '<nop>')

-- TODO: Searching (vimgrep, ack, etc)

