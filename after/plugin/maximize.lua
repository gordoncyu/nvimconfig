mxm = require('maximize')
mxm.setup({
    plugins = {
        aerial = { enable = false }, -- enable aerial.nvim integration
        tree = { enable = false },   -- enable nvim-tree.lua integration
    }
})
vim.keymap.set({'n', 'v', 's'}, "<leader>z", mxm.toggle, {desc="toggle ZenMode"})
