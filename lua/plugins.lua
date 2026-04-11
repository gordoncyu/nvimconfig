-- Must be set before plugins load
vim.g.tmux_navigator_no_mappings = 1
vim.g.mkdp_filetypes = { "markdown" }

local function gh(repo)
    return "https://github.com/" .. repo
end

local plugins = {
    -- Shared dependencies
    { gh("nvim-lua/plenary.nvim") },
    { gh("nvim-tree/nvim-web-devicons") },
    { gh("MunifTanjim/nui.nvim") },

    -- File tree
    { { src = gh("nvim-neo-tree/neo-tree.nvim"), version = "v3.x" } },

    -- UI / visual
    { gh("bronson/vim-crosshairs") },
    { gh("folke/which-key.nvim") },
    { gh("declancm/maximize.nvim") },
    { gh("JellyApple102/flote.nvim") },
    { gh("kepano/flexoki-neovim") },
    { gh("rcarriga/nvim-notify") },
    { gh("Bekaboo/dropbar.nvim") },
    { gh("lukas-reineke/indent-blankline.nvim") },

    -- Fuzzy finding
    { gh("nvim-telescope/telescope.nvim") },
    { gh("nvim-telescope/telescope-ui-select.nvim") },
    { gh("nvim-telescope/telescope-fzf-native.nvim"),
      build = function(ev) vim.system({'make'}, {cwd = ev.data.path}) end },

    -- File management
    { gh("kelly-lin/ranger.nvim") },

    -- Git
    { gh("lewis6991/gitsigns.nvim") },
    { gh("tpope/vim-fugitive") },
    { gh("theprimeagen/git-worktree.nvim") },

    -- Edit history
    { gh("bloznelis/before.nvim") },

    -- Treesitter
    { gh("nvim-treesitter/nvim-treesitter") },
    { gh("nvim-treesitter/nvim-treesitter-context") },
    { gh("nvim-treesitter/nvim-treesitter-textobjects") },
    { gh("mks-h/treesitter-autoinstall.nvim") },
    { gh("windwp/nvim-ts-autotag") },

    -- Text objects & selection
    { gh("chrisgrieser/nvim-various-textobjs") },
    { gh("sustech-data/wildfire.nvim") },

    -- Navigation / motion
    { "https://codeberg.org/andyg/leap.nvim" },
    { gh("unblevable/quick-scope") },
    { { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" } },
    { gh("christoomey/vim-tmux-navigator") },

    -- Editing utilities
    { gh("echasnovski/mini.move") },
    { gh("kylechui/nvim-surround") },
    { gh("windwp/nvim-autopairs") },
    { gh("numToStr/Comment.nvim") },
    { gh("tummetott/unimpaired.nvim") },
    { gh("mbbill/undotree") },

    -- Snippets
    { gh("L3MON4D3/LuaSnip") },
    { gh("saadparwaiz1/cmp_luasnip") },

    -- Completion
    { gh("hrsh7th/nvim-cmp") },
    { gh("hrsh7th/cmp-nvim-lsp") },
    { gh("hrsh7th/cmp-nvim-lsp-signature-help") },
    { gh("hrsh7th/cmp-buffer") },
    { gh("hrsh7th/cmp-path") },
    { gh("hrsh7th/cmp-cmdline") },
    { gh("hrsh7th/cmp-nvim-lua") },
    { gh("petertriho/cmp-git") },

    -- LSP
    { gh("neovim/nvim-lspconfig") },
    { gh("williamboman/mason.nvim") },
    { gh("williamboman/mason-lspconfig.nvim") },
    { gh("bfredl/nvim-luadev") },

    -- Java
    { gh("mfussenegger/nvim-jdtls") },
    { gh("hdiniz/vim-gradle") },

    -- Notebooks / polyglot
    { gh("jmbuhr/otter.nvim") },
    { gh("luk400/vim-jukit") },

    -- Web / markup
    { gh("cameron-wags/rainbow_csv.nvim") },
    { gh("barrett-ruth/live-server.nvim") },
    { gh("iamcco/markdown-preview.nvim"),
      build = function(ev) vim.system({'npm', 'install'}, {cwd = ev.data.path .. '/app'}) end },
    { gh("glacambre/firenvim"),
      build = function(ev)
          if not ev.data.active then vim.cmd.packadd('firenvim') end
          vim.cmd('call firenvim#install(0)')
      end },

    -- Tpope essentials
    { gh("tpope/vim-repeat") },
    { gh("tpope/vim-eunuch") },
    { gh("tpope/vim-obsession") },

    -- Yank utilities
    { gh("inkarkat/vim-ingo-library") },
    { gh("inkarkat/vim-RepeatableYank") },

    -- Misc
    { gh("ThePrimeagen/vim-be-good") },
}

-- Registered before vim.pack.add() so hooks fire on install as well as update
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
        for _, p in ipairs(plugins) do
            if p.build then
                local spec = p[1]
                local name = type(spec) == 'table' and spec.name or spec:match('[^/]+$')
                if name == ev.data.spec.name then
                    p.build(ev)
                    break
                end
            end
        end
    end,
})

vim.pack.add(vim.tbl_map(function(p) return p[1] end, plugins))
