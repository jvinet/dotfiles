-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- If in Termux or some other hamstrung environment, we may not be able to
-- remap Capslock or Ctrl to Esc. This is an acceptable workaround.
map("i", "kj", "<esc>")

-- Switch '0' and '^'
map("n", "0", "_")
map("n", "^", "999h")
map("n", "<localleader>0", "999h")

map("n", "<localleader>q", ":nohlsearch<cr>")
