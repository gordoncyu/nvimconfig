require('nvim-treesitter').install({
    "javascript", "typescript", "json", "html", "java", "c_sharp",
    "cpp", "c", "elixir", "lua", "python", "vim", "vimdoc", "query", "sql", "regex",
})

-- auto-install + highlighting for any filetype you open
require("treesitter-autoinstall").setup({ highlight = true })

-- autotag
require('nvim-ts-autotag').setup({
    opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
    },
})

-- Textobject options
require('nvim-treesitter-textobjects').setup({
    select = {
        lookahead = true,
        selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = '<c-v>',
        },
        include_surrounding_whitespace = function(stuff)
            local obj = stuff.query_string

            if string.find(obj, "%.inner") or string.find(obj, "%.[lr]hs") then
                return false
            end

            local multiline_outer = {
                ["@function.outer"]    = false,
                ["@function.inner"]    = false,
                ["@class.outer"]       = false,
                ["@call.outer"]        = false,
                ["@comment.outer"]     = false,
                ["@conditional.outer"] = false,
                ["@assignment.outer"]  = false,
                ["@block.outer"]       = false,
                ["@loop.outer"]        = false,
                ["@return.outer"]      = false,
                ["@statement.outer"]   = false,
            }
            if multiline_outer[obj] == false then
                return false
            end

            return true
        end,
    },
})

-- Textobject keymaps
local sel = require('nvim-treesitter-textobjects.select')
local maps = {
    { "af", "@function.outer"    }, { "if", "@function.inner"    },
    { "aC", "@class.outer"       }, { "iC", "@class.inner"       },
    { "ac", "@call.outer"        }, { "ic", "@call.inner"        },
    { "a#", "@comment.outer"     }, { "i#", "@comment.inner"     },
    { "a?", "@conditional.outer" }, { "i?", "@conditional.inner" },
    { "a=", "@assignment.outer"  }, { "=l", "@assignment.rhs"    },
    { "=h", "@assignment.lhs"    }, { "i=", "@assignment.inner"  },
    { "aa", "@parameter.outer"   }, { "ia", "@parameter.inner"   },
    { "ah", "@attribute.outer"   }, { "ih", "@attribute.inner"   },
    { "ab", "@block.outer"       }, { "ib", "@block.inner"       },
    { "al", "@loop.outer"        }, { "il", "@loop.inner"        },
    { "in", "@number.inner"      }, { "an", "@number.inner"      },
    { "ar", "@return.outer"      }, { "ir", "@return.inner"      },
    { "a/", "@regex.outer"       }, { "i/", "@regex.inner"       },
    { "aS", "@statement.outer"   }, { "iS", "@statement.outer"   },
}
for _, km in ipairs(maps) do
    vim.keymap.set({ "x", "o" }, km[1], function()
        sel.select_textobject(km[2], "textobjects")
    end)
end
