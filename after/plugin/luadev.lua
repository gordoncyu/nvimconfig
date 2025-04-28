
vim.keymap.set("n", "<leader>nl", "<Plug>(Luadev-Run)", { desc = "LuaDev: Eval motion" })
vim.keymap.set("v", "<leader>nl", "<Plug>(Luadev-Run)", { desc = "LuaDev: Eval visual selection" })

vim.api.nvim_create_user_command("Luadev", function()
    local a = vim.api

    local sr = vim.o.splitright
    vim.o.splitright = true
    vim.cmd("vsplit")
    vim.o.splitright = sr

    -- Get current window (left side)
    local lua_edit_win = a.nvim_get_current_win()
    local lua_edit_buf = a.nvim_create_buf(true, false)
    a.nvim_win_set_buf(lua_edit_win, lua_edit_buf)
    a.nvim_buf_set_option(lua_edit_buf, "filetype", "lua")
    a.nvim_buf_set_option(lua_edit_buf, "buftype", "")

    -- Now create a horizontal split inside this vertical split
    vim.cmd("split")

    -- Bottom window is where Luadev will go
    local repl_win = a.nvim_get_current_win()

    -- Start luadev output in the bottom window
    local luadev = require("luadev")

    -- Manually create Luadev's buffer if needed
    if not luadev.buf then
        luadev.create_buf()
    end

    -- Attach Luadev buffer to this window
    a.nvim_win_set_buf(repl_win, luadev.buf)

    -- Update Luadev win handle
    luadev.win = repl_win
end, { desc = "Open LuaDev split with editor + REPL" })

