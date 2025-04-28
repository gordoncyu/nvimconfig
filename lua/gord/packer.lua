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
            'bronson/vim-crosshairs',
            config = function ()
                local cross_on = true
                vim.opt.cursorline = cross_on
                vim.opt.cursorcolumn = cross_on
                vim.keymap.set({'n', 'x'}, "<leader>toc", function()
                            cross_on = not cross_on
                            vim.opt.cursorline = cross_on
                            vim.opt.cursorcolumn = cross_on
                end, {desc="toggle cursor crosshair"})
            end,
        }

        use {
            "folke/which-key.nvim",
            config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
            end
        }

        use {
            'declancm/maximize.nvim',
            config = function() 
                mxm = require('maximize')
                mxm.setup({
                    plugins = {
                        aerial = { enable = false }, -- enable aerial.nvim integration
                        dapui = { enable = false },  -- enable nvim-dap-ui integration
                        tree = { enable = false },   -- enable nvim-tree.lua integration
                    }
                }) 
                vim.keymap.set({'n', 'v', 's'}, "<leader>z", mxm.toggle, {desc="toggle ZenMode"})
            end
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

        -- git gutter
        use 'lewis6991/gitsigns.nvim'

        -- edit list
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

        -- top status bar path file class func dir
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

        -- move visual selection
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
        -- unix commands integrated
        use 'tpope/vim-repeat'
        use 'tpope/vim-eunuch'

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
        -- use {
        --     "adalessa/markdown-preview.nvim",
        --     requires = {
        --         "nvim-lua/plenary.nvim",
        --     },
        --     config = function()
        --         require("markdown-preview").setup()
        --     end,
        -- }

    end,
    config = {
        git = {
            subcommands = packer_overrides.git_subcommands
        },
    }
}
