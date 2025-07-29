require('neodev').setup({
    library = { plugins = {}, types = true },
})

local lsp_zero = require('lsp-zero');
local tbuiltin = require('telescope.builtin')

lsp_zero.preset("recommended")
-- local lsp_zero_ui_float_border = 'shadow';

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })

    local function get_opts(desc)
        return { buffer = bufnr, remap = false, desc = desc }
    end

    vim.keymap.set("n", "gd", function() tbuiltin.lsp_definitions() end, get_opts("go to definition"))
    vim.keymap.set("n", "gi", function() tbuiltin.lsp_implementations() end, get_opts("go to definition"))
    vim.keymap.set("n", "gr", function() tbuiltin.lsp_references() end, get_opts("go to references"))
    vim.keymap.set("n", "gc", function() tbuiltin.lsp_incoming_calls() end, get_opts("go to function calls"))
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, get_opts("show symbol details"))
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, get_opts("view diagnostic"))
    vim.keymap.set("n", "<leader>vbd", function() tbuiltin.diagnostics({ bufnr = 0 }) end, get_opts("view all diagnostics buffer-wide"))
    vim.keymap.set("n", "<leader>vad", function() tbuiltin.diagnostics() end, get_opts("view all diagnostics project-wide"))
    vim.keymap.set("n", "<leader>vws", function() tbuiltin.lsp_workspace_symbols() end, get_opts("view symbols project-wide"))
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, get_opts("view code actions"))
    vim.keymap.set("n", "<leader>vs", function() vim.lsp.buf.signature_help() end, get_opts("view signature"))
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, get_opts("go to next diagnostic"))
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, get_opts("go to previous diagnostic"))
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, get_opts("rename symbol"))
end)

require("mason").setup()
require("mason-lspconfig").setup {
    handlers = {
        lsp_zero.default_setup,
        jdtls = lsp_zero.noop,
    },
}

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Insert }
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

local luasnip = require('luasnip')

-- vim.keymap.set('i', '<C-s><Tab>', function()
--     luasnip.jump(1)
-- end, {desc="luasnip jump to next"})
--
-- vim.keymap.set('i', '<C-s><S-Tab>', function()
--     luasnip.jump(-1)
-- end, {desc="luasnip jump to previous"})
--
-- vim.keymap.set({'n', 'c', 'i'}, '<C-s><C-a>', function()
--     cmp.abort()
-- end, {desc="abort completion"})

vim.keymap.set('i', '<C-s>', function()
    luasnip.jump(1)
end, {desc="luasnip jump to next"})

-- vim.keymap.set('i', '<C-S>', function()
--     luasnip.jump(-1)
-- end, {desc="luasnip jump to previous"})

vim.o.cedit = '<C-\\><C-f>'
vim.keymap.set('c', '<C-f>',function()
    cmp.abort()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-f>", true, false, true), 'n', true)
end, {desc="opens the command-line window"})

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
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
        { name = 'buffer' },
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
        { name = 'cmdline' },
        { name = 'buffer' },
    })
})

-- (Optional) Configure lua language server for neovim
--require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
local lspconfig = require('lspconfig')
lspconfig.gleam.setup({})
lspconfig.texlab.setup({})
lspconfig.racket_langserver.setup({})
lspconfig.koka.setup{}

lsp_zero.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

lsp_zero.setup()
