local g = vim.g
local o = vim.o
local cmd = vim.cmd

----------------------------------------------------------------------------
-- [[ Setting options ]]
----------------------------------------------------------------------------
-- See `:help o`

o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2

-- Set highlight on search
o.hlsearch = true

-- Make line numbers default
o.number = true

-- Enable mouse mode
o.mouse = 'a'

-- Enable break indent
o.breakindent = true
-- Auto indent
o.autoindent = true
o.smartindent = true

-- Endless line width
o.textwidth = 0
-- Do not wrap lines automatically
o.wrap = false

-- Folding
o.foldmethod = 'indent'
o.foldlevel = 99
-- Don't bother folding small blocks
o.foldminlines=5

--o.cursorline = true

-- Show matching brackets when cursor is over them
o.showmatch = true

-- Searching
-- Case insensitive searching UNLESS /C or capital in search
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.hlsearch = true

-- Save undo history
o.undofile = true

-- Decrease update time
o.updatetime = 250
o.signcolumn = 'yes'

-- Set colorscheme
o.termguicolors = true
require('tokyonight').setup({
  transparent = false, -- do not set the background color
  dim_inactive = true,
  lualine_bold = true,
  hide_inactive_statusline = false,
  styles = {
    functions = {bold = true},
    keywords = {italic = true},
    comments = {italic = true}
  },
  on_highlights = function(hl, c)
    hl.VertSplit = {
      fg = c.cyan
    }
  end
})
cmd [[colorscheme tokyonight-night]]
cmd [[highlight winseparator guibg=none, guifg=#888888]]

--require("gruvbox").setup({
--  undercurl = true,
--  underline = true,
--  bold = true,
--  italic = true,
--  strikethrough = true,
--  invert_selection = false,
--  invert_signs = false,
--  invert_tabline = false,
--  invert_intend_guides = false,
--  inverse = true, -- invert background for search, diffs, statuslines and errors
--  contrast = "", -- can be "hard", "soft" or empty string
--  palette_overrides = {},
--  overrides = {},
--  dim_inactive = false,
--  transparent_mode = false,
--})

-- Set completeopt to have a better completion experience
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Jump 5 lines when running out of screen
o.scrolljump = 5
-- Indicate jump out of the screen when 3 lines away
o.scrolloff = 3

-- Lower the time that Vim waits to look for matching keymaps (ms)
o.timeoutlen = 400

-- See ':help fo-table' for an explanation of each option char
o.formatoptions = 'qctnj1'

-- TODO
--o.listchars='tab:|.,trail:.,extends:>,precedes:<,eol:'

-- [[ Basic Keymaps ]]
g.mapleader = '\\'
g.maplocalleader = '\\'


-- [[ Input overrides ]]
cmd('cabbrev Vi vi')
cmd('cabbrev W w')
