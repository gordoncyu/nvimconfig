local autopairs = require('nvim-autopairs')
autopairs.setup({
    fast_wrap = {},
})
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

-- autopairs.remove_rule('(')
-- autopairs.remove_rule('{')
-- autopairs.remove_rule('[')
autopairs.remove_rule('"""')
-- autopairs.remove_rule('`')
autopairs.remove_rule('```')

local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
