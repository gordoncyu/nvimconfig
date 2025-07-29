local cross_on = true
vim.opt.cursorline = cross_on
vim.opt.cursorcolumn = cross_on
vim.keymap.set({'n', 'x'}, "<leader>toc", function()
            cross_on = not cross_on
            vim.opt.cursorline = cross_on
            vim.opt.cursorcolumn = cross_on
end, {desc="toggle cursor crosshair"})
