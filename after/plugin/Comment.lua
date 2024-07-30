require('Comment').setup({
    mappings = {
        basic = false,
        extra = false,
    },
})

api = require('Comment.api')
config = require('Comment.config'):get()

vim.keymap.set({'n'}, '<leader>c', api.call('toggle.linewise', 'g@'), { expr = true })
vim.keymap.set({'n'}, '<leader>b', api.call('toggle.blockwise', 'g@'), { expr = true })

local esc = vim.api.nvim_replace_termcodes(
    '<ESC>', true, false, true
)

vim.keymap.set('x', '<leader>c', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    api.toggle.linewise(vim.fn.visualmode())
end)

vim.keymap.set('x', '<leader>b', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    api.toggle.blockwise(vim.fn.visualmode())
end)
