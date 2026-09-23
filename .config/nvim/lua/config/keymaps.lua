vim.g.mapleader = " "
vim.g.maplocalleader = " "
local map = vim.keymap.set
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("v", "<", "<gv")
map("v", ">", ">gv")

map({ "n", "i", "v", "c" }, "<Up>", "<nop>")
map({ "n", "i", "v", "c" }, "<Down>", "<nop>")
map({ "n", "i", "v", "c" }, "<Left>", "<nop>")
map({ "n", "i", "v", "c" }, "<Right>", "<nop>")
