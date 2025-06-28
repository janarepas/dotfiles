vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'folke/tokyonight.nvim'
    use 'wbthomason/packer.nvim'
    use 'theprimeagen/harpoon'
    -- 👉  Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        requires = {
            { 'nvim-lua/plenary.nvim' }
        }
    }
    -- 🚀 Natív FZF gyorsító a Telescope-hoz
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        cond = function()
            return vim.fn.executable('make') == 1
        end
    }
    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
    }
end)
