local mxm = require('maximize')
mxm.setup({
    plugins = {
        aerial = { enable = false },
        dapui  = { enable = false },
        tree   = { enable = false },
    }
})
vim.keymap.set({'n', 'v', 's'}, "<leader>z", mxm.toggle, {desc="toggle ZenMode"})
