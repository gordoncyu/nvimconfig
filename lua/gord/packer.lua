-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

local packer = require('packer')
packer.util = require('packer.util')

-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

local packer = require('packer')
local ok, packer_overrides = pcall(require, 'packer_overrides') -- Attempt to load the file

-- If the file couldn't be loaded, use default values
if not ok then
    packer_overrides = {
        git_subcommands = {
            submodules = 'submodule update --init --recursive',
            update = 'pull --ff-only --progress --force',
            fetch = 'fetch --progress --force',
        },
    }
end

return require('packer').startup({
    function(use)
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        use {
            'nvim-telescope/telescope.nvim', tag = '0.1.2',
            -- or                            , branch = '0.1.x',
            requires = { { 'nvim-lua/plenary.nvim' } }
        }

        use({
            'rose-pine/neovim',
            as = 'rose-pine',
            config = function()
                vim.cmd('colorscheme rose-pine')
            end
        })

        use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
        use('nvim-treesitter/playground')
        use('theprimeagen/harpoon')
        use('mbbill/undotree')
        use('tpope/vim-fugitive')

        use {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v2.x',
            requires = {
                -- LSP Support
                { 'neovim/nvim-lspconfig' },             -- Required
                { 'williamboman/mason.nvim' },           -- Optional
                { 'williamboman/mason-lspconfig.nvim' }, -- Optional

                -- Autocompletion
                { 'hrsh7th/nvim-cmp' },     -- Required
                { 'hrsh7th/cmp-nvim-lsp' }, -- Required
                { 'L3MON4D3/LuaSnip' },     -- Required
            }
        }

        use('ray-x/lsp_signature.nvim')

        use('sustech-data/wildfire.nvim')

        use('ThePrimeagen/vim-be-good')

        use('luk400/vim-jukit')
    end,
    config = {
        git = {
            subcommands = packer_overrides.git_subcommands
        },
    }
})
