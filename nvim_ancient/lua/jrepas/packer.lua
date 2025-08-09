return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'              -- Packer
    use 'folke/tokyonight.nvim'               -- Theme
    use 'theprimeagen/harpoon'                -- Fast navigation
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.6', requires = { 'nvim-lua/plenary.nvim' } } -- Telescope search
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = function() return vim.fn.executable('make') == 1 end } -- Fuzzy Finder
    use 'nvim-treesitter/nvim-treesitter'     -- Syntax highlighting
end)
