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
        local handle = io.popen("which ranger")
        local result = handle:read("*a")
        handle:close()
        if result:match("ranger") then
            require("ranger-nvim").open(true)
        else
            vim.cmd('Ex')
        end
    end,
})
