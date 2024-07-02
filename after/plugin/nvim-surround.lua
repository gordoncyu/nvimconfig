require("nvim-surround").setup({
    keymaps = {
        insect = "<C-g>a",
        insert_line = "<C-g>A",
        normal = "yA",
        normal_cur = "yAA",
        normal_line = "yR",
        normal_cur_line = "yRR",
        visual = "A",
        visual_line = "gA",
        delete = "dA",
        change = "cA",
        change_line = "cR",
    },
})
