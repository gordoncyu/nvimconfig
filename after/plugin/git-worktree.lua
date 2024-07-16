vim.api.nvim_create_user_command(
    "Cgwt",
    function(opts)
        local args = vim.split(opts.args, " ")
        local path = args[1]
        local branch = args[2] or "master"  -- Default branch if not provided
        local upstream = args[3] or "origin"  -- Default upstream if not provided
        require("git-worktree").create_worktree(path, branch, upstream)
    end,
    { nargs = '*', desc = "Create a git worktree with optional branch and upstream" }
)

vim.api.nvim_create_user_command(
    "Sgwt",
    function(opts)
        local path = opts.args
        require("git-worktree").switch_worktree(path)
    end,
    { nargs = 1, desc = "Switch to an existing git worktree" }
)

vim.api.nvim_create_user_command(
    "Dgwt",
    function(opts)
        local path = opts.args
        require("git-worktree").delete_worktree(path)
    end,
    { nargs = 1, desc = "Delete an existing git worktree" }
)

vim.api.nvim_create_user_command(
    "Tgwt",
    function()
        require('telescope').extensions.git_worktree.git_worktrees()
    end,
    { desc = "List git worktrees using Telescope" }
)

vim.api.nvim_create_user_command(
    "Tcgwt",
    function()
        require('telescope').extensions.git_worktree.create_git_worktree()
    end,
    { desc = "Create a git worktree using Telescope" }
)

vim.keymap.set('n', '<leader>gwc', function()
    require('telescope').extensions.git_worktree.create_git_worktree()
end, { noremap = true, silent = true, desc = "Create git worktree using Telescope" })

vim.keymap.set('n', '<leader>gwm', function()
    require('telescope').extensions.git_worktree.git_worktrees()
end, { noremap = true, silent = true, desc = "List git worktrees using Telescope" })

