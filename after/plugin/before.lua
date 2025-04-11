local before = require('before')
before.setup({
    history_size = 99,
    history_wrap_enabled = false,
    telescope_for_preview = true
})

-- Jump to previous entry in the edit history
vim.keymap.set('n', 'g;', before.jump_to_last_edit, {desc="jump to last edit"})

-- Jump to next entry in the edit history
vim.keymap.set('n', 'g,', before.jump_to_next_edit, {desc="jump to next edit"})

-- Move edit history to quickfix (or telescope)
vim.keymap.set('n', '<leader>vch', before.show_edits_in_telescope, {desc="view change history"})
