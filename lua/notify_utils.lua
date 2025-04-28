local notify = require("notify")

local M = {}
--Render notify.history() in a floating scratch window.
---@param opts table|nil
---    opts.bufnr (integer) – reuse an existing buffer number
---    opts.win   (string|table) – one of:
---        "float" (default)        – floating window
---        "split" / "vsplit"       – horiz / vert split
---        "tab"                    – new tabpage
---        {win_config table}       – full nvim_open_win() config
---    opts.notifs  (table|nil) dump ONLY this list instead of notify.history()
function M.open_notification_buffer(opts)
    opts = opts or {}
    local api    = vim.api

    -- Build lines + highlight tuples {lnum, col_start, col_end, hl}
    local lines, hls = {}, {}
    local ns = api.nvim_create_namespace("NotifyHistory")

    local source = opts.notifs or notify.history()
    for _, n in ipairs(source) do
        local segs = {
            {vim.fn.strftime(notify._config().time_formats().notification_history, n.time), "NotifyLogTime"},
            {" ", "MsgArea"},
            {n.title[1], "NotifyLogTitle"},
            {#n.title[1] > 0 and " " or "", "MsgArea"},
            {n.icon, "Notify" .. n.level .. "Title"},
            {" ", "MsgArea"},
            {n.level, "Notify" .. n.level .. "Title"},
            {" ", "MsgArea"},
            {table.concat(n.message, " "), "MsgArea"},
        }

        local col, lnum = 0, #lines
        local line = {}

        for _, seg in ipairs(segs) do
            local txt, hl = seg[1], seg[2]
            table.insert(line, txt)
            local len = #txt
            if len > 0 then
                table.insert(hls, {lnum, col, col + len, hl})
                col = col + len
            end
        end

        table.insert(lines, table.concat(line))
    end

    --------------------------------------------------------------------------
    -- Buffer setup (reuse or create) ----------------------------------------
    --------------------------------------------------------------------------
    local buf = opts.bufnr
    if not (buf and api.nvim_buf_is_valid(buf)) then
        buf = api.nvim_create_buf(false, true)
        api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    end
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    for _, h in ipairs(hls) do
        api.nvim_buf_add_highlight(buf, ns, h[4], h[1], h[2], h[3])
    end

    --------------------------------------------------------------------------
    -- Window display ---------------------------------------------------------
    --------------------------------------------------------------------------
    local win
    if type(opts.win) == "table" then
        -- explicit win_config table → floating win
        win = api.nvim_open_win(buf, false, opts.win)
    else
        local kind = opts.win or "float"
        if kind == "split" or kind == "vsplit" then
            vim.cmd(kind)
            win = api.nvim_get_current_win()
            api.nvim_win_set_buf(win, buf)
        elseif kind == "tab" then
            vim.cmd("tabnew")
            win = api.nvim_get_current_win()
            api.nvim_win_set_buf(win, buf)
        else -- default floating
            local cfg = {
                relative = "editor",
                width    = math.min(vim.o.columns - 4, 100),
                height   = math.min(#lines, vim.o.lines - 4),
                row      = 2,
                col      = 2,
                border   = "single",
                style    = "minimal",
                noautocmd = true,
            }
            win = api.nvim_open_win(buf, false, cfg)
        end
    end
end

return M
