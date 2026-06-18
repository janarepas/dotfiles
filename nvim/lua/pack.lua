--tokyonight
require("tokyonight").setup {
  transparent = true,
}
vim.cmd.colorscheme("tokyonight-night")

--treesitter
require("nvim-treesitter").setup {
  ensure_installed = { "lua", "vim", "vimdoc", "bash", "markdown" },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
}
