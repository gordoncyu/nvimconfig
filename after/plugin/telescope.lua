local builtin = require('telescope.builtin')
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local nutils = require("notify_utils")

local function dynamic_send_selected(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    if picker.results_title == "Notifications" then
        local sel    = picker:get_multi_selection()
        if vim.tbl_isempty(sel) then
            sel = { action_state.get_selected_entry() }
        end
        local list = vim.tbl_map(function(e) return e.value end, sel)
        actions.close(prompt_bufnr)
        nutils.open_notification_buffer({win="tab", notifs=list})
        return
    end
    return actions.send_selected_to_qflist(prompt_bufnr, " ")
end

local function dynamic_send_all(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    vim.notify("HERE")
    if picker.results_title == "Notifications" then
        vim.notify("HERE")
        local manager = picker.manager
        local list    = {}
        for entry in manager:iter() do
            table.insert(list, entry.value)
        end
        actions.close(prompt_bufnr)
        nutils.open_notification_buffer({win="tab", notifs=list})
        return
    end
    return actions.send_to_qflist(prompt_bufnr, " ")
end

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
telescope.setup({
    defaults = {
        mappings = {
            n = {
                ["dd"] = actions.delete_buffer,
                ["<leader>da"] = dynamic_send_all,
                ["<leader>ds"] = dynamic_send_selected,
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

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local function command_picker()
    local cmds = vim.api.nvim_get_commands({})
    local cmd_items = {}
    for name, cmd in pairs(cmds) do
        table.insert(cmd_items, name)
    end

    pickers.new({}, {
        prompt_title = "Commands",
        finder = finders.new_table {
            results = cmd_items,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local exec = function()
                local entry = action_state.get_selected_entry()
                if not entry then return end
                local cmd = entry[1]
                actions.close(prompt_bufnr)
                vim.cmd(cmd)
            end

            local to_cmdline = function()
                local entry = action_state.get_selected_entry()
                if not entry then return end
                actions.close(prompt_bufnr)
                vim.fn.feedkeys(":" .. entry[1])
            end

            local to_register = function()
                local entry = action_state.get_selected_entry()
                if not entry then return end
                actions.close(prompt_bufnr)
                vim.fn.setreg('"', entry[1])
            end

            map('i', '<CR>', exec)
            map('i', '<C-y>', to_cmdline)

            map('n', 'yy', to_register)

            return true
        end
    }):find()
end

vim.keymap.set("n", "<leader>nc", command_picker, { desc = "Fuzzy Command Picker" })

