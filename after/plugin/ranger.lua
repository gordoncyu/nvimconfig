require("ranger-nvim").setup({ 
    replace_netrw = false,
    enable_cmds = true,
    ui = {
        y = .50,
        height = .90,
    },
})

vim.api.nvim_set_keymap("n", "<leader>pv", "", {
    noremap = true,
    callback = function()
        require("ranger-nvim").open(true)
    end,
})
