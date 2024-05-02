local flote = require('flote')

flote.setup {
    q_to_quit = false,
    window_style = '',
}

vim.keymap.set("n", "<leader>pn", "<cmd>Flote<CR>")
