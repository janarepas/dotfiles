-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Indentation: two spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Appearance
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.colorcolumn = ""

-- Scrolling margins
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Search and substitution
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

-- Split window placement
vim.opt.splitbelow = true
vim.opt.splitright = true

-- System clipboard
-- Keep ordinary registers usable on headless hosts without a provider.
if vim.fn.has("clipboard") == 1 then
  vim.opt.clipboard:append("unnamedplus")
end

-- Filename characters
vim.opt.isfname:append("@-@")

-- Cursor: block in normal mode, vertical bar in insert mode
vim.opt.guicursor =
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Recovery and backups
vim.opt.swapfile = true
vim.opt.backup = false

-- Preserve undo history across sessions
local undo_dir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undo_dir, "p", 448) -- 0700; existing directory permissions are preserved.

vim.opt.undodir = undo_dir
vim.opt.undofile = true
