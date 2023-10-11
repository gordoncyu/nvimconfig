vim.api.nvim_create_user_command('We', function ()
    vim.cmd('w')
    vim.cmd('e')
end,
{nargs=0})
