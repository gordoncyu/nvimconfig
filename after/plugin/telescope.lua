local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gbc', builtin.git_bcommits, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
--vim.keymap.set('n', '<leader>gs', builtin.git_status, {})

local telescope = require('telescope')
local tactions = require('telescope.actions')
telescope.setup({
    defaults = {
        mappings = {
            n = {
                ["dd"] = tactions.delete_buffer
            }
        }
    }
})
