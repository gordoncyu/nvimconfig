require('neodev').setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
})

local lsp_zero = require('lsp-zero');
local tbuiltin = require('telescope.builtin')

lsp_zero.preset("recommended")
lsp_zero_ui_float_border = 'shadow';

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() tbuiltin.lsp_definitions() end, opts)
    vim.keymap.set("n", "gr", function() tbuiltin.lsp_references() end, opts)
    vim.keymap.set("n", "goc", function() tbuiltin.lsp_outgoing_calls() end, opts)
    vim.keymap.set("n", "gic", function() tbuiltin.lsp_incoming_calls() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vde", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<leader>vr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>voc", function() vim.lsp.buf.outgoing_calls() end, opts)
    vim.keymap.set("n", "<leader>vic", function() vim.lsp.buf.incoming_calls() end, opts)
    vim.keymap.set("n", "<leader>vdi", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>vbd", function() tbuiltin.diagnostics({ bufnr = 0 }) end, opts)
    vim.keymap.set("n", "<leader>vad", function() tbuiltin.diagnostics() end, opts)
    vim.keymap.set("n", "<leader>vws", function() tbuiltin.lsp_workspace_symbols() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vss", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
end)

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { 'tsserver', 'eslint', 'jsonls', 'jdtls', 'lua_ls', 'pyright', 'rust_analyzer', 'clangd'},
    handlers = {
        lsp_zero.default_setup,
        jdtls = lsp_zero.noop,
    },
}

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp_mappings,
    sources = cmp.config.sources({
        { name = 'nvim_lua' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'path' }
    }, {
        { name = 'buffer', keyword_length = 5 },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- (Optional) Configure lua language server for neovim
--require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp_zero.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

lsp_zero.setup()
