local tbuiltin = require('telescope.builtin')

-- Merge cmp capabilities into every server
local capabilities = vim.tbl_deep_extend('force',
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
)

-- Global capabilities for all servers
vim.lsp.config('*', {
    capabilities = capabilities,
})

-- LspAttach fires for every client regardless of server-level on_attach overrides
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local bufnr = ev.buf
        local function opts(desc)
            return { buffer = bufnr, remap = false, desc = desc }
        end

        vim.keymap.set("n", "gd", function() tbuiltin.lsp_definitions() end, opts("go to definition"))
        vim.keymap.set("n", "gi", function() tbuiltin.lsp_implementations() end, opts("go to definition"))
        vim.keymap.set("n", "gr", function() tbuiltin.lsp_references() end, opts("go to references"))
        vim.keymap.set("n", "gc", function() tbuiltin.lsp_incoming_calls() end, opts("go to function calls"))
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts("show symbol details"))
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts("view diagnostic"))
        vim.keymap.set("n", "<leader>vbd", function() tbuiltin.diagnostics({ bufnr = 0 }) end, opts("view all diagnostics buffer-wide"))
        vim.keymap.set("n", "<leader>vad", function() tbuiltin.diagnostics() end, opts("view all diagnostics project-wide"))
        vim.keymap.set("n", "<leader>vws", function() tbuiltin.lsp_workspace_symbols() end, opts("view symbols project-wide"))
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts("view code actions"))
        vim.keymap.set("n", "<leader>vs", function() vim.lsp.buf.signature_help() end, opts("view signature"))
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts("go to next diagnostic"))
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts("go to previous diagnostic"))
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts("rename symbol"))
    end,
})

-- lua_ls: replaces neodev, teaches it about the nvim runtime
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
            },
        },
    },
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { 'ts_ls', 'eslint', 'jsonls', 'jdtls', 'lua_ls', 'basedpyright', 'rust_analyzer', 'clangd' },
})

-- Auto-enable all mason-installed servers (jdtls excluded — handled by nvim-jdtls)
local to_enable = vim.tbl_filter(
    function(s) return s ~= 'jdtls' end,
    require('mason-lspconfig').get_installed_servers()
)

-- print("Enabling: " .. PSTR(to_enable))

vim.lsp.enable(to_enable)

-- Non-mason servers (only enable if the executable is present)
local non_mason = {
    { server = 'gleam',            exe = 'gleam'  },
    { server = 'texlab',           exe = 'texlab' },
    { server = 'racket_langserver', exe = 'racket' },
    { server = 'koka',             exe = 'koka'   },
}
for _, s in ipairs(non_mason) do
    if vim.fn.executable(s.exe) == 1 then
        vim.lsp.enable(s.server)
    end
end

-- Diagnostic sign icons
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN]  = '▲',
            [vim.diagnostic.severity.HINT]  = '⚑',
            [vim.diagnostic.severity.INFO]  = '»',
        },
    },
})

-- Completion
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Insert }

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lua' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    }),
})

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    }),
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' },
    },
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
    }, {
        { name = 'cmdline' },
        { name = 'buffer' },
    }),
})

-- Luasnip jump
vim.keymap.set('i', '<C-s>', function()
    require('luasnip').jump(1)
end, { desc = "luasnip jump to next" })

-- Command-line window
vim.o.cedit = '<C-\\><C-f>'
vim.keymap.set('c', '<C-f>', function()
    cmp.abort()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-f>", true, false, true), 'n', true)
end, { desc = "opens the command-line window" })
