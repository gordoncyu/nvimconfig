local leap = require('leap')

for _, _1_ in ipairs({
    { { "n", "x", "o" }, "s", "<Plug>(leap-forward)", "Leap forward" },
    { { "n", "x", "o" }, "S", "<Plug>(leap-backward)", "Leap backward" },
    { { "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", "Leap from window" },
}) do
    local modes = _1_[1]
    local lhs = _1_[2]
    local rhs = _1_[3]
    local desc = _1_[4]
    for _0, mode in ipairs(modes) do
        -- local rhs_2a = vim.fn.mapcheck(lhs, mode)
        -- if (rhs_2a == "") then
            vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
        -- else
        --     if (rhs_2a ~= rhs) then
        --         local msg = ("leap.nvim config mapping configuration " .. "found conflicting mapping for " .. lhs .. ": " .. rhs_2a)
        --         vim.notify(msg, vim.log.levels.WARN)
        --     else
        --     end
        -- end
    end
end

leap.opts.special_keys = {
    next_target = '<enter>',
    prev_target = { '<backspace>', '<tab>' },
    next_group = '<space>',
    prev_group = { '<backspace>', '<tab>' },
}

leap.opts.case_sensitive = false
leap.opts.equivalence_classes = {
    -- case insensitivity for special characters
    '`~',
    ' \t\r\n',
    '1!',
    '2@',
    '3#',
    '4$',
    '5%',
    '6^',
    '7&',
    '8*',
    '9(',
    '0)',
    '-_',
    '=+',
    '[{',
    ']}',
    '|\\',
    ';:',
    '\'"',
    '<,',
    '>.',
    '/?',
}

-- leap.add_default_mappings()
