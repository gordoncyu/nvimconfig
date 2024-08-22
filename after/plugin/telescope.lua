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

local telescope = require('telescope')
local tactions = require('telescope.actions')
telescope.setup({
    defaults = {
        mappings = {
            n = {
                ["dd"] = tactions.delete_buffer
            }
        },
        file_ignore_patterns = {
            "node_modules"
        }
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown{}
        }
    }
})

telescope.load_extension("ui-select")
telescope.load_extension("git_worktree")
