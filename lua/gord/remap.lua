vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- set things
vim.keymap.set("n", "<leader>stw", function ()
    local num = vim.fn.input('Enter tab width: ')
    num = tonumber(num)
    if num then
        vim.opt.tabstop = num
        vim.opt.shiftwidth = num
    else
        print('Invalid input')
    end
end)
local mouse_on_setting = vim.o.mouse
vim.keymap.set('n', '<leader>tm', function()
    if vim.o.mouse ~= "" then
        mouse_on_setting = vim.o.mouse
        vim.o.mouse = ""
        print("Mouse disabled")
    else
        vim.o.mouse = mouse_on_setting
        print("Mouse enabled")
    end
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>nh", "<cmd>noh<CR>")
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<CR>")
vim.keymap.set("n", "<leader>tn", "<cmd>set number!<CR><cmd>set relativenumber!<CR>")
local function toggle_diagnostic_underline()
    local groups = {
        "DiagnosticUnderlineError",
        "DiagnosticUnderlineWarn",
        "DiagnosticUnderlineInfo",
        "DiagnosticUnderlineHint",
        "DiagnosticUnderlineOk"
    }

    for _, group in ipairs(groups) do
        -- Get current highlight settings
        local hl = vim.api.nvim_get_hl_by_name(group, true)
        
        -- Toggle underline
        hl.underline = not hl.underline
        
        -- Set the modified highlight
        vim.api.nvim_set_hl(0, group, hl)
    end
end

vim.keymap.set('n', '<leader>tdu', toggle_diagnostic_underline, { noremap = true, silent = true })


-- nav keeping cursor centered
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste over selection without clearing clipboard
vim.keymap.set("x", "<leader>p", "\"_dP")

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
-- paste from
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>P", "\"+P")
vim.keymap.set("v", "<leader>P", "\"+P")

-- visually select over pasted text
vim.keymap.set("n", "gp", "`[v`]")

-- gV
vim.keymap.set("n", "gV", "gvV")

-- v/V/<C-v> does not toggle, only enables
for i, key in pairs({"v", "V", ""}) do
    vim.keymap.set("x", key, function ()
        local mode = vim.api.nvim_get_mode().mode
        if mode == key then
            return
        end
        vim.api.nvim_feedkeys(key, "n", true)
        print(key)
    end)
end

-- Q is evil
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>=", function()
    vim.lsp.buf.format()
end)

-- quickfixlist stuff
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace word in whole file
vim.keymap.set("n", "<leader>sub", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- gonil
vim.keymap.set("n", "<leader>sgn", "oif err != nil {<CR>}<Esc>kA<CR>")

local function delete_nested()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local current_line_indent = vim.fn.indent(current_line)
    local lines_in_buffer = vim.fn.line("$")

    local next_line = current_line + 1
    while true do
        if next_line > lines_in_buffer then
            break
        end

        local next_line_indent = vim.fn.indent(next_line)
        local next_line_empty = vim.fn.getline(next_line) == ""

        if not next_line_empty and next_line_indent <= current_line_indent then
            break
        end

        vim.api.nvim_buf_set_lines(0, next_line - 1, next_line, false, {})
        lines_in_buffer = lines_in_buffer - 1
    end
end

-- delete all nested of greater indent
vim.keymap.set("n", "<leader>dn", delete_nested, {noremap=true})
-- delete all nested of equal indent of greater
vim.keymap.set("n", "<leader>din", function ()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local current_line_indent = vim.fn.indent(current_line)

    local prev_line = current_line - 1

    while prev_line > 0 do
        local prev_line_indent = vim.fn.indent(prev_line)
        local prev_line_empty = vim.fn.getline(prev_line) == ""

        if not prev_line_empty and prev_line_indent < current_line_indent then
            break
        end

        prev_line = prev_line - 1
    end

    if prev_line == 0 then
        return
    end

    vim.api.nvim_win_set_cursor(0, {prev_line, 0})

    delete_nested()
end, {noremap=true})
