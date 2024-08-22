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
            "folke/which-key.nvim",
            config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
            end
        }

        use {
            "folke/zen-mode.nvim",
            config = function()
                require("zen-mode").setup({
                    plugins = {
                        options = {
                            laststatus = 3, -- keep status line
                        }
                    }
                })
                vim.keymap.set({'n', 'v', 's'}, "<leader>z", '<cmd>ZenMode<CR>')
            end,
        }

        use 'JellyApple102/flote.nvim'

        use {
            'nvim-telescope/telescope.nvim', tag = '0.1.2',
            -- or                            , branch = '0.1.x',
            requires = { { 'nvim-lua/plenary.nvim' } }
        }

        use 'nvim-telescope/telescope-ui-select.nvim'
        use 'kelly-lin/ranger.nvim'

        use {
            'leath-dub/snipe.nvim',
            config = function()
                require('snipe').setup({
                    ui = {
                        position = "center",
                    },
                })
                vim.keymap.set({'n', 'x'}, 'go', function () 
                    require("snipe").open_buffer_menu()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>q', true, false, true), 'n', false)
                end)
            end,
        }

        use { 'kepano/flexoki-neovim', as = 'flexoki', }

        use {
            'cameron-wags/rainbow_csv.nvim',
            config = function()
                require('rainbow_csv').setup()
            end,
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

        use 'lewis6991/gitsigns.nvim'

        use 'bloznelis/before.nvim'

        use {
            'freddiehaddad/feline.nvim',
            requires = {
                'lewis6991/gitsigns.nvim'
            },
            config = function()
                require('feline').setup()
            end
        }

        use {
            "utilyre/barbecue.nvim",
            tag = "*",
            requires = {
                "lewis6991/gitsigns.nvim",
                "SmiteshP/nvim-navic",
                "nvim-tree/nvim-web-devicons", -- optional dependency
            },
            after = "nvim-web-devicons",       -- keep this if you're using NvChad
                config = function()
                    require("barbecue").setup()
                end,
        }

        use {
            'rcarriga/nvim-notify',
            config = function()
                vim.notify = require('notify')
                vim.keymap.set({'n', 'x'}, '<leader>vn', function() require('telescope').extensions.notify.notify() end, {desc = "View notifications"})
            end,
        }

        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate'
        }

        use 'nvim-treesitter/playground'
        use('nvim-treesitter/nvim-treesitter-context')
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
            config = function ()
                require("git-worktree").setup()
            end,
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

        use 'mfussenegger/nvim-jdtls'
        use 'hdiniz/vim-gradle'

        use {
            "mfussenegger/nvim-dap",
            dependencies = {
                "theHamsta/nvim-dap-virtual-text",
                "rcarriga/nvim-dap-ui",
            },
        }
        use 'mfussenegger/nvim-dap-ui'
        use 'theHamsta/nvim-dap-virtual-text'
        use 'jay-babu/mason-nvim-dap.nvim'

        use 'echasnovski/mini.move'
        use 'kylechui/nvim-surround'
        use 'windwp/nvim-autopairs'
        use 'windwp/nvim-ts-autotag'
        use 'numToStr/Comment.nvim'
        use {
            'tummetott/unimpaired.nvim',
            config = function ()
                require('unimpaired').setup()
            end
        }
        use 'tpope/vim-eunuch'

        use 'ggandor/leap.nvim'

        use 'unblevable/quick-scope'
        use 'lukas-reineke/indent-blankline.nvim'

        use 'folke/neodev.nvim'
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

        use 'christoomey/vim-tmux-navigator'

        use '907th/vim-auto-save'

        use {
            'barrett-ruth/live-server.nvim',
            build = 'npm add -g live-server',
            cmd = { 'LiveServerStart', 'LiveServerStop' },
            config = function ()
                require('live-server').setup()
            end
        }

        use {
            "iamcco/markdown-preview.nvim",
            run = "cd app && npm install",
            setup = function()
                vim.g.mkdp_filetypes = { "markdown" }
            end,
            ft = { "markdown" },
        }
    end,
    config = {
        git = {
            subcommands = packer_overrides.git_subcommands
        },
    }
}
