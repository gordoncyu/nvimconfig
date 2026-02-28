-- Disable default keymaps so we can set our own below
vim.g.nvim_surround_no_mappings = true

require("nvim-surround").setup({})

vim.keymap.set("i", "<C-g>a", "<Plug>(nvim-surround-insert)")
vim.keymap.set("i", "<C-g>A", "<Plug>(nvim-surround-insert-line)")
vim.keymap.set("n", "yA",  "<Plug>(nvim-surround-normal)")
vim.keymap.set("n", "yAA", "<Plug>(nvim-surround-normal-cur)")
vim.keymap.set("n", "yR",  "<Plug>(nvim-surround-normal-line)")
vim.keymap.set("n", "yRR", "<Plug>(nvim-surround-normal-cur-line)")
vim.keymap.set("x", "A",   "<Plug>(nvim-surround-visual)")
vim.keymap.set("x", "gA",  "<Plug>(nvim-surround-visual-line)")
vim.keymap.set("n", "dA",  "<Plug>(nvim-surround-delete)")
vim.keymap.set("n", "cA",  "<Plug>(nvim-surround-change)")
vim.keymap.set("n", "cR",  "<Plug>(nvim-surround-change-line)")
