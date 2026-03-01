require('otter').setup({
    lsp = {
        -- Refresh diagnostics on write (default). Add 'InsertLeave' if you want
        -- them to update as you type, but it may be slow.
        diagnostic_update_events = { 'BufWritePost' },
    },
    buffers = {
        -- Write the otter buffer to disk so external linters (e.g. eslint) can
        -- find it. Disable if you hit performance issues.
        write_to_disk = false,
    },
})

local function activate_otter()
    local ft = vim.bo.filetype
    if ft == 'html' then
        require('otter').activate({ 'javascript', 'css' }, true, true)
    elseif ft == 'markdown' then
        require('otter').activate(nil, true, true)
    end
end

-- BufEnter covers both: re-entering an already-open buffer and opening new ones.
-- This also handles the case where FileType fired before this file was sourced.
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '*.md', '*.html' },
    callback = activate_otter,
    desc = 'Activate otter.nvim for embedded code blocks',
})

-- Also activate for any matching buffers already open when this file is sourced
-- (e.g. nvim foo.md — the FileType event fires before after/plugin loads).
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
        local ft = vim.bo[buf].filetype
        if ft == 'markdown' or ft == 'html' then
            vim.api.nvim_buf_call(buf, activate_otter)
        end
    end
end
