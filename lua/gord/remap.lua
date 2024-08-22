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

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
-- paste from
vim.keymap.set({"n", "v"}, "<leader>p", "\"+p")
vim.keymap.set({"n", "v"}, "<leader>P", "\"+P")

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

-- replace word in whole file
vim.keymap.set("n", "<leader>sub", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- gonil
vim.keymap.set("n", "<leader>sgn", "oif err != nil {<CR>}<Esc>kA<CR>")

