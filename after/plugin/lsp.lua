local lsp = require('lsp-zero').preset({})
local tbuiltin = require('telescope.builtin')

lsp.preset("recommended")

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { 'tsserver', 'eslint', 'jsonls', 'jdtls', 'lua_ls', 'pyright', 'rust_analyzer' }
}

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({ buffer = bufnr })

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() tbuiltin.lsp_definitions() end, opts)
    vim.keymap.set("n", "gr", function() tbuiltin.lsp_references() end, opts)
    vim.keymap.set("n", "goc", function() tbuiltin.lsp_outgoing_calls() end, opts)
    vim.keymap.set("n", "gic", function() tbuiltin.lsp_incoming_calls() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>vbd", function() tbuiltin.diagnostics({bufnr=0}) end, opts)
    vim.keymap.set("n", "<leader>vad", function() tbuiltin.diagnostics() end, opts)
    vim.keymap.set("n", "<leader>vws", function() tbuiltin.lsp_workspace_symbols() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vss", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)

    --vim.api.nvim_create_autocmd("CursorHold", {
        --buffer = bufnr,
        --callback = function()
            --local opts = {
                --focusable = false,
                --close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                --border = 'rounded',
                --source = 'always',
                --prefix = ' ',
                --scope = 'cursor',
            --}
            --vim.diagnostic.open_float(nil, opts)
        --end
    --})
end)

-- (Optional) Configure lua language server for neovim
--require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

lsp.setup()

local sigcfg = {
    hint_enable = false,
}
require("lsp_signature").setup(sigcfg)
