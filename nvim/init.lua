-- Core editing works without plugins or network access.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("settings")
require("privacy")
require("keymap")
require("pack")
