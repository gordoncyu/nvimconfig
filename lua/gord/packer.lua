-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

local packer = require('packer')
packer.util = require('packer.util')

-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

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

return packer.startup {
    function(use)
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        use {
            'glacambre/firenvim',
            run = ':call firenvim#install(0)',
        }

        use{
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            requires = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons",
                "MunifTanjim/nui.nvim",
            },
        }

        use {
            'bronson/vim-crosshairs',
        }

        use {
            "folke/which-key.nvim",
        }

        use {
            'declancm/maximize.nvim',
        }

        -- use {
        --     "folke/zen-mode.nvim",
        --     config = function()
        --         require("zen-mode").setup({
        --             plugins = {
        --                 options = {
        --                     laststatus = 3, -- keep status line
        --                 }
        --             }
        --         })
        --         vim.keymap.set({'n', 'v', 's'}, "<leader>z", '<cmd>ZenMode<CR>', {desc="toggle ZenMode"})
        --     end,
        -- }

        -- floating per-project note buffer
        use 'JellyApple102/flote.nvim'

        use {
            'nvim-telescope/telescope.nvim', tag = '0.1.2',
            -- or                            , branch = '0.1.x',
            requires = { { 'nvim-lua/plenary.nvim' } }
        }

        -- menu select fuzzy finding
        use 'nvim-telescope/telescope-ui-select.nvim'
        use 'kelly-lin/ranger.nvim'

        -- color scheme
        use { 'kepano/flexoki-neovim', as = 'flexoki', }

        use {
            'cameron-wags/rainbow_csv.nvim',
            ft = {
                'csv',
                'tsv',
                'csv_semicolon',
                'csv_whitespace',
                'csv_pipe',
                'rfc_csv',
                'rfc_semicolon'
            }
        }

        -- git gutter
        use 'lewis6991/gitsigns.nvim'

        -- edit list
        use 'bloznelis/before.nvim'

        use({
            'Bekaboo/dropbar.nvim',
            -- optional: fuzzy‑find inside the breadcrumb menus
            requires = { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        })

        use {
            'rcarriga/nvim-notify',
        }

        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate'
        }

        use 'nvim-treesitter/playground'
        use'nvim-treesitter/nvim-treesitter-context'
        use {
            "nvim-treesitter/nvim-treesitter-textobjects",
            after = "nvim-treesitter",
            requires = "nvim-treesitter/nvim-treesitter",
        }
        use "chrisgrieser/nvim-various-textobjs"
        -- use 'nvim-treesitter/nvim-treesitter-context'
        use 'theprimeagen/harpoon'
        use {
            'theprimeagen/git-worktree.nvim',
        }
        use 'mbbill/undotree'
        use 'tpope/vim-fugitive'

        use {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v3.x',
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

        -- move visual selection
        use 'echasnovski/mini.move'
        use 'kylechui/nvim-surround'
        use 'windwp/nvim-autopairs'
        use 'windwp/nvim-ts-autotag'
        use 'numToStr/Comment.nvim'
        use {
            'tummetott/unimpaired.nvim',
        }
        -- unix commands integrated
        use 'tpope/vim-repeat'
        use 'tpope/vim-eunuch'

        use 'tpope/vim-obsession'

        use 'inkarkat/vim-ingo-library'
        use {
            'inkarkat/vim-RepeatableYank',
            dependencies = {
                'inkarkat/vim-ingo-library',
                'tpope/vim-repeat',
            },
        }

        use 'ggandor/leap.nvim'

        -- blessing upon this world
        use 'unblevable/quick-scope'
        use 'lukas-reineke/indent-blankline.nvim'

        -- nvim lsp
        use 'folke/neodev.nvim'
        use 'bfredl/nvim-luadev'
        use 'neovim/nvim-lspconfig'
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-nvim-lsp-signature-help'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-nvim-lua'
        use 'L3MON4D3/LuaSnip'
        use 'saadparwaiz1/cmp_luasnip'
        use 'petertriho/cmp-git'

        use 'sustech-data/wildfire.nvim'

        use 'ThePrimeagen/vim-be-good'

        use 'luk400/vim-jukit'

    end,
    config = {
        git = {
            subcommands = packer_overrides.git_subcommands
        },
    }
}
