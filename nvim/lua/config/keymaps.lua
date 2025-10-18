-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Move the selected line(s) down
map("v", "J", ":m '>+1<CR>gv=gv")

-- Move the selected line(s) up
map("v", "K", ":m '<-2<CR>gv=gv")

-- Get out of the file and Go to the Explorer
map("n", "<leader>be", ":Explore %:p:h<CR>", { desc = "Open netrw in current file's dir" })

-- Switch to the last opened buffer
map("n", "<leader>bb", ":b#<CR>", { desc = "Switch to last opened buffer" })

-- Window command manually
local opts = { noremap = true, silent = true }
map("n", "<leader>wv", "<C-w>v", { desc = "Split Window Vertically", unpack(opts) })
map("n", "<leader>wh", "<C-w>h", { desc = "Split Window Horizontally", unpack(opts) })
map("n", "<leader>wq", "<C-w>q", { desc = "Close Current Window", unpack(opts) })
map("n", "<leader>wo", "<C-w>o", { desc = "Close Other Windows", unpack(opts) })
map("n", "<leader>wh", "<C-w>h", { desc = "Go to Left Window", unpack(opts) })
map("n", "<leader>wl", "<C-w>l", { desc = "Go to Right Window", unpack(opts) })
map("n", "<leader>wk", "<C-w>k", { desc = "Go to Upper Window", unpack(opts) })
map("n", "<leader>wj", "<C-w>j", { desc = "Go to Lower Window", unpack(opts) })
