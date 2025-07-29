vim.notify = require("notify")

local nutils = require("notify_utils")

vim.keymap.set({'n', 'x'}, '<leader>vnq', function() require('telescope').extensions.notify.notify() end, {desc = "View notifications in telescope"})
vim.keymap.set({'n', 'x'}, '<leader>vnf', function() nutils.open_notification_buffer({win="float"}) end, {desc = "View notifications in a floating window"})
vim.keymap.set({'n', 'x'}, '<leader>vnt', function() nutils.open_notification_buffer({win="tab"}) end, {desc = "View notifications in a new tab"})
vim.keymap.set({'n', 'x'}, '<leader>vns', function() nutils.open_notification_buffer({win="split"}) end, {desc = "View notifications in a split window"})
vim.keymap.set({'n', 'x'}, '<leader>vnd', function() nutils.open_notification_buffer({bufnr=0}) end, {desc = "Dump notifications to current buffer"})

