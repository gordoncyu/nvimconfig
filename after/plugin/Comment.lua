require('Comment').setup({
    mappings = {
        basic = false,
        extra = false,
    },
})

local api = require('Comment.api')
-- local config = require('Comment.config'):get()

vim.api.nvim_del_keymap('n', 'gc')
vim.api.nvim_del_keymap('v', 'gc')
vim.api.nvim_del_keymap('n', 'gcc')

vim.keymap.set('n', '<leader><leader>c', function()
    return vim.v.count == 0
        and '<Plug>(comment_toggle_linewise_current)'
        or '<Plug>(comment_toggle_linewise_count)'
end, { expr = true })
vim.keymap.set('n', '<leader><leader>b', function()
    return vim.v.count == 0
        and '<Plug>(comment_toggle_blockwise_current)'
        or '<Plug>(comment_toggle_blockwise_count)'
end, { expr = true })

vim.keymap.set({'n'}, '<leader>c', api.call('toggle.linewise', 'g@'), { expr = true, desc = "toggle comment linewise (operator pending)" })
vim.keymap.set({'n'}, '<leader>b', api.call('toggle.blockwise', 'g@'), { expr = true, desc = "toggle comment blockwise (operator pending)" })

vim.keymap.set({'n'}, '<leader>c', api.call('toggle.linewise', 'g@'), { expr = true, desc = "toggle comment linewise (operator pending)" })

local esc = vim.api.nvim_replace_termcodes(
    '<ESC>', true, false, true
)

vim.keymap.set('x', '<leader>c', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    api.toggle.linewise(vim.fn.visualmode())
end, {desc="toggle visual selection comment linewise"})

vim.keymap.set('x', '<leader>b', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    api.toggle.blockwise(vim.fn.visualmode())
end, {desc="toggle visual selection comment blockwise"})
