local last_fugitive_curpos = nil
local function open (dir)
    vim.fn.chdir(dir)
    vim.cmd("Git")
    local timer = vim.loop.new_timer()
    local fug_win = vim.api.nvim_get_current_win()
    local fug_buf = vim.api.nvim_win_get_buf(fug_win)
    local ui = vim.api.nvim_list_uis()[1]
    local width_pad = math.floor((ui.width / 3.14))
    local win_width = (ui.width - width_pad)
    local height_pad = math.floor((ui.height / 3.14))
    local win_height = (ui.height - height_pad)
    local win_opts = {border = "rounded", col = ((ui.width - win_width) / 2), height = win_height, relative = "editor", row = ((ui.height - win_height) / 2), width = win_width}
    local function mod_fugitive()
        vim.keymap.set("n", "q", function () vim.api.nvim_win_close(fug_win, true) end, 
        {
                buffer = fug_buf,
                desc = "Close fugitive window with just q"
        })
        local fug_floatwin = vim.api.nvim_create_augroup("fugitiveFloatwin", {clear = true})
        vim.api.nvim_create_autocmd("BufLeave",
        {
                buffer = fug_buf,
                callback = function () 
                        local curpos = vim.api.nvim_win_get_cursor(fug_win)
                        last_fugitive_curpos = curpos
                        vim.api.nvim_win_close(fug_win, true) 
                        vim.api.nvim_del_augroup_by_id(fug_floatwin)
                end,
                desc = "Close fugitive floating window after we leave it",
                group = fug_floatwin,
        })
        local ok, last_curpos = pcall(vim.api.nvim_buf_get_var, fug_buf, "last_curpos")
        if not ok then
            last_curpos = {1, 0}
        end
        vim.api.nvim_win_set_cursor(fug_win, last_curpos)
        if last_fugitive_curpos then
            vim.api.nvim_win_set_cursor(fug_win, last_fugitive_curpos)
        else
            vim.api.nvim_win_set_cursor(fug_win, {1, 0})
        end
        return vim.api.nvim_win_set_config(fug_win, win_opts)
    end
    return timer:start(1, 0, vim.schedule_wrap(mod_fugitive))
end
vim.keymap.set("n", "<leader>gs", function() open("./") end, {desc="git status ui (fugitive)"})
