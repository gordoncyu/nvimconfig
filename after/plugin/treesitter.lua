-- Function to capture the output of a shell command
function os.capture(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

-- Function to check if a command exists
function command_exists(cmd)
    local status = os.execute(cmd .. " >/dev/null 2>&1")
    return status == 0
end

-- Detect GCC version
local gcc_version_output = os.capture("gcc --version")
local gcc_version = gcc_version_output:match("%d+%.%d+%.%d+")

-- Default compiler
local compiler = "gcc"

if gcc_version then
    local major, minor, mini = gcc_version:match("(%d+)%.(%d+)%.(%d+)")
    major = tonumber(major)
    minor = tonumber(minor)

    if major < 5 or (major == 5 and minor < 1) then
        -- Check if tcc is installed
        if not command_exists("tcc -v") then
            error("treesitter.lua: gcc version < 5.1.0; c++14 not supported. tcc also not found.")
        else
            print("treesitter.lua: gcc version < 5.1.0; falling back on tcc")
            compiler = "tcc"
        end
    end
end

require'nvim-treesitter.install'.compilers = {compiler} 

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "javascript", "typescript", "json", "html", "java", "c_sharp", "cpp", "c", "elixir", "lua", "python", "vim", "vimdoc", "query", "sql", "regex" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
  },

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,

    -- text-objects extension
  },

  textobjects = {
      select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["aC"] = "@class.outer",
              ["iC"] = "@class.inner",
              ["ac"] = "@call.outer",
              ["ic"] = "@call.inner",
              ["a#"] = "@comment.outer",
              ["i#"] = "@comment.inner",
              ["a?"] = "@conditional.outer",
              ["i?"] = "@conditional.inner",
              ["a="] = "@assignment.outer",
              ["=r"] = "@assignment.rhs",
              -- ["=l"] = "@assignment.lhs",
              -- ["i="] = "@assignment.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ah"] = "@attribute.outer", -- really only in html (and astro lmao)
              ["ih"] = "@attribute.inner", -- can't think of any other single char that isn't already taken
              ["aB"] = "@block.outer",
              ["iB"] = "@block.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["in"] = "@number.inner",
              ["an"] = "@number.inner",
              ["ar"] = "@return.outer",
              ["ir"] = "@return.inner",
              ["a/"] = "@regex.outer",
              ["i/"] = "@regex.inner",
              ["aS"] = "@statement.outer",
              ["iS"] = "@statement.outer",
          },

          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = true,
      },
  },
}
