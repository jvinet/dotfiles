-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- The root dir of the project/workspace. First walk up the directory tree
-- looking for a .git directory. If not found, just use the CWD as the project
-- root.
vim.g.root_spec = { ".git", "cwd" }
-- Don't autoformat after save.
vim.g.autoformat = false
vim.g.snacks_animate = false

vim.opt.relativenumber = false
