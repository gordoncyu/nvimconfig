local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file, {desc="add file to harpoon"})
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, {desc="toggle harpoon ui"})

vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, {desc="open harppon entry 1"})
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, {desc="open harppon entry 2"})
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, {desc="open harppon entry 3"})
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, {desc="open harppon entry 4"})
vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end, {desc="open harppon entry 5"})
vim.keymap.set("n", "<leader>6", function() ui.nav_file(6) end, {desc="open harppon entry 6"})
vim.keymap.set("n", "<leader>7", function() ui.nav_file(7) end, {desc="open harppon entry 7"})
vim.keymap.set("n", "<leader>8", function() ui.nav_file(8) end, {desc="open harppon entry 8"})
vim.keymap.set("n", "<leader>9", function() ui.nav_file(9) end, {desc="open harppon entry 9"})
vim.keymap.set("n", "<leader>0", function() ui.nav_file(0) end, {desc="open harppon entry 10"})
