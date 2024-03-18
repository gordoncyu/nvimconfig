vim.o.mouse = ""
vim.o.foldmethod = "marker"
vim.o.foldmarker = "<fold<<,>fold>>"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

--vim.opt.hlsearch=false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.opt.scrollback = 50000

-- Line numbers etc in Netrw
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"

vim.defer_fn(function()
    vim.cmd([[
    hi Pmenu blend=0
    ]])
end, 100)
