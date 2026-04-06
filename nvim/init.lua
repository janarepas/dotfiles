vim.g.mapleader = " "

require("config")
local builtin = require('telescope.builtin')
vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.colorcolumn = "80,120"
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.keymap.set("n", "<leader>e", ":Ex<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set({"n","i", "v"}, "<leader>q", ":q<CR>")
