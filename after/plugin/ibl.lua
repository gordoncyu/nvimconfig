
vim.api.nvim_set_hl(0, "iblWhitespacePrimary", { bg = "#0c0c0c" })

local highlight = {
    "iblWhitespacePrimary",
    "Whitespace",
}

require("ibl").setup {
    indent = { highlight = highlight, char = "", priority = 0 },
    whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
    },
    scope = { enabled = true },
}
