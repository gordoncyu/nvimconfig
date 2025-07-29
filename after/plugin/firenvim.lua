vim.g.firenvim_config = {
    globalSettings = { alt = "all" },
    localSettings = {
        [".*.?"] = {takeover = 'never', priority = 1000},
    }
}
