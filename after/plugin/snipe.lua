require('snipe').setup({
    ui = {
        position = "center",
    },
})
vim.keymap.set({'n', 'x'}, 'go', function () 
    require("snipe").open_buffer_menu()
end, {desc="go to buffer"})
