require("various-textobjs").setup {
	lookForwardSmall = 15,
	lookForwardBig = 45,

	useDefaultKeymaps = false,
	-- disabledKeymaps = {},

	notifyNotFound = true,
}

vim.keymap.set({ "o", "x" }, "ii", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", {desc="indentation"})
vim.keymap.set({ "o", "x" }, "ai", "<cmd>lua require('various-textobjs').indentation('outer', 'inner')<CR>", {desc="indentation and line above"})
vim.keymap.set({ "o", "x" }, "iI", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", {desc="indentation"})
vim.keymap.set({ "o", "x" }, "aI", "<cmd>lua require('various-textobjs').indentation('outer', 'outer')<CR>", {desc="indentation and lines above/below"})

vim.keymap.set({ "o", "x" }, "ri", "<cmd>lua require('various-textobjs').restOfIndentation()<CR>", {desc="rest of indentation"})

vim.keymap.set({ "o", "x" }, "ig", "<cmd>lua require('various-textobjs').greedyOuterIndentation('inner')<CR>", {desc="greedy outer indentation"})
vim.keymap.set({ "o", "x" }, "ag", "<cmd>lua require('various-textobjs').greedyOuterIndentation('outer')<CR>", {desc="greedy outer indentation, includes a blank like"})

vim.keymap.set({ "o", "x" }, "is", "<cmd>lua require('various-textobjs').subword('inner')<CR>", {desc="subword"})
vim.keymap.set({ "o", "x" }, "as", "<cmd>lua require('various-textobjs').subword('outer')<CR>", {desc="subword including trailing '_- '"})

vim.keymap.set({ "o", "x" }, "rc", "<cmd>lua require('various-textobjs').toNextClosingBracket()<CR>", {desc="to next bracket"})

vim.keymap.set({ "o", "x" }, "q", "<cmd>lua require('various-textobjs').toNextQuotationMark()<CR>", {desc="to next quote"})

vim.keymap.set({ "o", "x" }, "iq", "<cmd>lua require('various-textobjs').anyQuote('inner')<CR>", {desc="any quote inner"})
vim.keymap.set({ "o", "x" }, "aq", "<cmd>lua require('various-textobjs').anyQuote('outer')<CR>", {desc="any quote outer"})

vim.keymap.set({ "o", "x" }, "ib", "<cmd>lua require('various-textobjs').anyBracket('inner')<CR>", {desc="any bracket inner"})
vim.keymap.set({ "o", "x" }, "ab", "<cmd>lua require('various-textobjs').anyBracket('outer')<CR>", {desc="any bracket outer"})

vim.keymap.set({ "o", "x" }, "rp", "<cmd>lua require('various-textobjs').restOfParagraph()<CR>", {desc="rest of paragraph"})

vim.keymap.set({ "o", "x" }, "gG", "<cmd>lua require('various-textobjs').entireBuffer()<CR>", {desc="everything lol"})

vim.keymap.set({ "o", "x" }, "h$", "<cmd>lua require('various-textobjs').nearEoL()<CR>", {desc="head eol"})

vim.keymap.set({ "o", "x" }, "g;", "<cmd>lua require('various-textobjs').lastChange()<CR>", {desc="last non-deleting change"})

vim.keymap.set({ "o", "x" }, "il", "<cmd>lua require('various-textobjs').lineCharacterwise('inner')<CR>", {desc="line characterwise"})
vim.keymap.set({ "o", "x" }, "al", "<cmd>lua require('various-textobjs').lineCharacterwise('outer')<CR>", {desc="line characterwise with indent and trailing spaces"})

vim.keymap.set({ "o", "x" }, "|", "<cmd>lua require('various-textobjs').column()<CR>", {desc="column, whatever that means. can take count"})

vim.keymap.set({ "o", "x" }, "iN", "<cmd>lua require('various-textobjs').notebookCell('inner')<CR>", {desc="cell inner"})
vim.keymap.set({ "o", "x" }, "aN", "<cmd>lua require('various-textobjs').notebookCell('outer')<CR>", {desc="cell outer"})

vim.keymap.set({ "o", "x" }, "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>", {desc="value inner"})
vim.keymap.set({ "o", "x" }, "av", "<cmd>lua require('various-textobjs').value('outer')<CR>", {desc="value outer"})

vim.keymap.set({ "o", "x" }, "ik", "<cmd>lua require('various-textobjs').key('inner')<CR>", {desc="key inner"})
vim.keymap.set({ "o", "x" }, "ak", "<cmd>lua require('various-textobjs').key('outer')<CR>", {desc="key outer"})

vim.keymap.set({ "o", "x" }, "iu", "<cmd>lua require('various-textobjs').url()<CR>", {desc="url inner"})
vim.keymap.set({ "o", "x" }, "au", "<cmd>lua require('various-textobjs').url()<CR>", {desc="url inner"})

vim.keymap.set({ "o", "x" }, "in", "<cmd>lua require('various-textobjs').number('inner')<CR>", {desc="in pure numbers"})
vim.keymap.set({ "o", "x" }, "an", "<cmd>lua require('various-textobjs').number('outer')<CR>", {desc="in numbers with -."})

vim.keymap.set({ "o", "x" }, "!", "<cmd>lua require('various-textobjs').diagnostic('wrap')<CR>", {desc="diagnostic"})
vim.keymap.set({ "o", "x" }, "i!", "<cmd>lua require('various-textobjs').diagnostic('wrap')<CR>", {desc="diagnostic"})
vim.keymap.set({ "o", "x" }, "a!", "<cmd>lua require('various-textobjs').diagnostic('wrap')<CR>", {desc="diagnostic"})

vim.keymap.set({ "o", "x" }, "iz", "<cmd>lua require('various-textobjs').closedFold('inner')<CR>", {desc="closed fold"})
vim.keymap.set({ "o", "x" }, "az", "<cmd>lua require('various-textobjs').closedFold('outer')<CR>", {desc="closed fold"})

vim.keymap.set({ "o", "x" }, "im", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>", {desc="chain member"})
vim.keymap.set({ "o", "x" }, "am", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>", {desc="chain member"})

vim.keymap.set({ "o", "x" }, "gw", "<cmd>lua require('various-textobjs').visibleInWindow()<CR>", {desc="all visible lines"})
vim.keymap.set({ "o", "x" }, "gW", "<cmd>lua require('various-textobjs').restOfWindow()<CR>", {desc="rest of visible lines"})
