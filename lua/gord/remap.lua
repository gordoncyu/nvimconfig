vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

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

-- Q is evil
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent ! tmux neww ~/.local/scripts/tms<CR>")
vim.keymap.set("n", "<leader>=", function()
    vim.lsp.buf.format()
    -- stupid clangd lsp format doesn't respect my 4 space indents; double those auto 2 space ones ez
    if vim.bo.filetype == 'c' then
        vim.cmd([[
            %s/^\(\s\+\)/\1\1/
        ]])
        vim.cmd("noh")
    end
end)

-- quickfixlist stuff
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace word in whole file
vim.keymap.set("n", "<leader>sub", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>chmx", "<cmd>!chmod +x %<CR>", { silent = true })

-- gonil
vim.keymap.set("n", "<leader>sgn", "oif err != nil {<CR>}<Esc>kA<CR>")
