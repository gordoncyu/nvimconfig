vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc="open file explorer (netrw)"})

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
end, {desc="set tab width"})
local mouse_on_setting = vim.o.mouse
vim.keymap.set('n', '<leader>tom', function()
    if vim.o.mouse ~= "" then
        mouse_on_setting = vim.o.mouse
        vim.o.mouse = ""
        print("Mouse disabled")
    else
        vim.o.mouse = mouse_on_setting
        print("Mouse enabled")
    end
end, { noremap = true, silent = true, desc="toggle mouse" })
vim.keymap.set("n", "<leader>nh", "<cmd>noh<CR>", {desc="disable highlight"})
vim.keymap.set("n", "<leader>tow", "<cmd>set wrap!<CR>", {desc="toggle line wrap"})
vim.keymap.set("n", "<leader>ton", "<cmd>set number!<CR><cmd>set relativenumber!<CR>", {desc="toggle relative line numbers"})
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
        local hl = vim.api.nvim_get_hl(0, {name=group})

        -- Toggle underline
        hl.underline = not hl.underline

        -- Set the modified highlight
        vim.api.nvim_set_hl(0, group, hl)
    end
end

vim.keymap.set('n', '<leader>todu', toggle_diagnostic_underline, { noremap = true, silent = true, desc="toggle diagnostic underlines" })
                vim.opt.cursorline = true
                vim.opt.cursorcolumn = true


-- tab things
vim.keymap.set('n', '<leader>tc', "<cmd>tabnew<CR>")
vim.keymap.set('n', '<leader>tx', "<cmd>tabclose<CR>")
vim.keymap.set('n', '<leader>tn', "<cmd>tabnext<CR>")
vim.keymap.set('n', '<leader>tN', "<cmd>tabprev<CR>")
for i=1,9 do vim.keymap.set('n', '<leader>t' .. i, "<cmd>" .. i .. "tabn<CR>", {desc="tab " .. i}) end
vim.keymap.set('n', '<leader>t' .. 0, "<cmd>" .. 10 .. "tabn<CR>", {desc="tab " .. 10})

-- nav keeping cursor centered
vim.keymap.set("n", "J", "mzJ`z", {desc="Join N lines; default is 2"})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc="scroll Down N lines (default: half a screen)"})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc="scroll N lines Upwards (default: half a screen)"})
vim.keymap.set("n", "G", "Gzz", {desc="cursor to line N, default last line"})
vim.keymap.set("n", "n", "nzzzv", {desc="repeat the latest '/' or '?' N times"})
vim.keymap.set("n", "N", "Nzzzv", {desc="repeat the latest '/' or '?' N times in"})

-- view registers
vim.keymap.set({'n', 'x'}, "<leader>re", "<cmd>registers<CR>", {desc="view registers"})

-- refresh theme
vim.keymap.set({'n', 'x'}, "<leader>rt", "<cmd>silent! exe \"so \" . stdpath(\"config\") . \"/after/plugin/flexoki.lua\" <CR>", {desc="refresh theme"})

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", {desc="yank to system clipboard"})
vim.keymap.set("v", "<leader>y", "\"+y", {desc="yank to system clipboard"})
vim.keymap.set("n", "<leader>Y", "\"+Y", {desc="yank N lines to system clipboard"})
-- paste from
vim.keymap.set({"n", "v"}, "<leader>p", "\"+p", {desc="paste from system clipboard"})
vim.keymap.set({"n", "v"}, "<leader>P", "\"+P", {desc="paste from system clipboard before cursor"})

-- visually select over pasted text
vim.keymap.set("n", "gp", "`[v`]", {desc="highlight over previously operated text"})
vim.keymap.set("n", "gP", "`[v`]V", {desc="highlight linewise over previously operated text"})

-- gV
vim.keymap.set("n", "gV", "gvV", {desc="reselect the previous Visual area linewise"})

-- v/V/<C-v> does not toggle, only enables
for _, key in pairs({"v", "V", ""}) do
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
vim.keymap.set("n", "Q", "<nop>", {desc="do nothing"})

vim.keymap.set("n", "<leader>=", function()
    vim.lsp.buf.format()
end, {desc="reformat buffer (with the lsp)"})

-- replace word in whole file
vim.keymap.set("n", "<leader>sub", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", {desc="replace all buffer occurences of symbol under cursor"})
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc="set the current file as executable" })

-- gonil
vim.keymap.set("n", "<leader>sgn", "oif err != nil {<CR>}<Esc>kA<CR>", {desc="input err != nil snippet"})

