require ('mason-nvim-dap').setup({
    ensure_installed = {'codelldb', 'javadbg', 'javatest', 'python'},
    handlers = {},
    automatic_installation = true,
})

local dap = require("dap")

local dapvt = require("nvim-dap-virtual-text")
dapvt.setup({
enabled = true,
virt_text_pos = 'eol',
show_stop_reason = true,
highlight_changed_variables = true
})

local dapui = require("dapui")
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set({'n', 't'}, "<leader>db", function() require'dap'.toggle_breakpoint() end, { silent = true })
vim.keymap.set({'n', 't'}, "<leader>dc", function() require'dap'.continue() end, { silent = true })
vim.keymap.set({'n', 't'}, "<leader>dov", function() require'dap'.step_over() end, { silent = true })
vim.keymap.set({'n', 't'}, "<leader>di", function() require'dap'.step_into() end, { silent = true })
vim.keymap.set({'n', 't'}, "<leader>dou", function() require'dap'.step_out() end, { silent = true })
vim.keymap.set({'n', 't'}, "<leader>dd", function() require'dap'.disconnect() end, { silent = true })
vim.keymap.set({'n', 't'}, "<leader>dut", function() require'dapui'.toggle() end, { silent = true })
vim.keymap.set({'n', 't'}, "<leader>dvt", function() require("nvim-dap-virtual-text").toggle() end, { noremap = true, silent = true })

vim.keymap.set('n', "<leader>djc", function() require('jdtls').test_class() end, { noremap = true, silent = true })
vim.keymap.set('n', "<leader>djm", function() require('jdtls').test_nearest_method() end, { noremap = true, silent = true })
