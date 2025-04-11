local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc="search project files"})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {desc="search open buffers"})
vim.keymap.set('n', '<leader>pg', builtin.git_files, {desc="search project git files"})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, {desc="search for string in files"})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {desc="search git commits"})
vim.keymap.set('n', '<leader>gbc', builtin.git_bcommits, {desc="search git commits with current buffer"})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {desc="search git branches"})

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
