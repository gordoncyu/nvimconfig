-- AI doesn't make me more productive it just enables me to rice ungodly things
-- > "Your scientists were so preoccupied with whether or not they could, they didn't stop to think if they should."
-- -- Dr. Ian Malcolm
-- Anyway, here's ranger but it's actually neotree plus some lua

-- let me just override the builtin so I can autonav to the created file/dir
-- also create file/dir at current depth rather than dir under cursor if dir is under cursor. why is this not the default smh vscode users are dumb

-- helper: returns true when a directory has **no** entries
local function dir_is_empty(path)
    local handle = vim.loop.fs_scandir(path)
    if not handle then             -- couldn’t open = treat as empty
        return true
    end
    return vim.loop.fs_scandir_next(handle) == nil
end

local custom_add_file = function(state)
    local node = state.tree:get_node()
    local parent_path
    -- If the cursor is on an **empty** directory, create *inside* it;
    -- otherwise stay at the current depth.
    if node.type == "directory" and dir_is_empty(node.path) then
        parent_path = node.path
    else
        parent_path = vim.fn.fnamemodify(node.path, ":h")
    end

    local input_name = vim.fn.input("New file name: ", "")
    if input_name == "" then return end

    local full_path = parent_path .. "/" .. input_name
    local file = io.open(full_path, "w")
    if file then 
        file:close()
        print("Created: " .. full_path)
    end

    require("neo-tree.sources.manager").refresh("filesystem")

    -- Move cursor to the newly created file
    vim.defer_fn(function()
        require("neo-tree.command").execute({
            action = "focus",
            source = "filesystem",
            position = "current",
            reveal_file = full_path,
        })
    end, 200)
end

local custom_add_directory = function(state)
    local node = state.tree:get_node()
    local parent_path
    if node.type == "directory" and dir_is_empty(node.path) then
        parent_path = node.path
    else
        parent_path = vim.fn.fnamemodify(node.path, ":h")
    end

    local input_name = vim.fn.input("New directory name: ", "")
    if input_name == "" then return end

    local full_path = parent_path .. "/" .. input_name
    local success = vim.fn.mkdir(full_path, "p")
    if success == 1 then
        print("Created directory: " .. full_path)
    end

    require("neo-tree.sources.manager").refresh("filesystem")

    -- Move cursor to the newly created directory  
    vim.defer_fn(function()
        require("neo-tree.command").execute({
            action = "focus",
            source = "filesystem", 
            position = "current",
            reveal_file = full_path,
        })
    end, 200)
end

-- implement a feature not even in neotree
_G.neotree_bookmarks = _G.neotree_bookmarks or {}

-- I don't actually know if all of these bindings work, claude just gave them to me so ¯\_(ツ)_/¯
local my_nt_mappings = {
    -- Ranger-style navigation 
    -- already default
    -- ["j"] = "next_node",                 -- ranger: j - down
    -- ["k"] = "prev_node",                 -- ranger: k - up
    ["h"] = "close_node",                -- ranger: h - close directory/go up
    ["l"] = "open",                      -- ranger: l - open file/directory

    -- Scrolling (custom functions since no built-in scroll commands)
    ["<C-u>"] = {
        function(state)
            local tree = state.tree
            vim.cmd("normal! " .. math.floor(vim.api.nvim_win_get_height(0) / 2) .. "k")
        end,
        desc = "Scroll up"
    },
    ["<C-d>"] = {
        function(state)
            local tree = state.tree
            vim.cmd("normal! " .. math.floor(vim.api.nvim_win_get_height(0) / 2) .. "j")
        end,
        desc = "Scroll down"
    },

    -- First/last navigation (custom functions)
    ["gg"] = {
        function(state)
            vim.cmd("normal! gg")
        end,
        desc = "Go to first node"
    },
    ["G"] = {
        function(state)
            vim.cmd("normal! G")
        end,
        desc = "Go to last node"
    },

    -- File operations (ranger-style)
    ["<CR>"] = "open",                   -- ranger: <CR> - open
    ["<C-v>"] = "open_vsplit",          -- ranger: <C-v> - vertical split
    ["<C-x>"] = "open_split",           -- ranger: <C-x> - horizontal split
    ["<C-t>"] = "open_tabnew",          -- ranger: <C-t> - new tab

    -- File management (ranger-style)
    ["%"] = custom_add_file,                       -- ranger: a - create file
    ["M"] = custom_add_directory,             -- ranger: A - create directory
    -- all of this just so I don't have to re-type-in the current filename
    ["A"] = {
        function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
                local current_name = vim.fn.fnamemodify(node.path, ":t")
                
                vim.ui.input({ 
                    prompt = "Rename to: ",
                    default = current_name  -- Pre-fill with current name
                }, function(new_name)
                    if new_name and new_name ~= "" and new_name ~= current_name then
                        local parent_dir = vim.fn.fnamemodify(node.path, ":h")
                        local new_path = parent_dir .. "/" .. new_name
                        
                        -- Rename the file
                        local success = vim.loop.fs_rename(node.path, new_path)
                        if success then
                            require("neo-tree.sources.manager").refresh("filesystem")
                            
                            -- Navigate to renamed file
                            vim.defer_fn(function()
                                require("neo-tree.command").execute({
                                    action = "focus",
                                    source = "filesystem",
                                    position = "current",
                                    reveal_file = new_path,
                                })
                            end, 100)
                        end
                    end
                end)
            end
        end,
        desc = "Rename with current name pre-filled"
    },
    ["cw"] = "rename",                   -- ranger: cw - rename (change word)
    ["d"] = "none",                      -- Disable the default d mappingc:w
    ["dD"] = "delete",                   -- ranger: dd - delete
    ["yy"] = "copy_to_clipboard",        -- ranger: yy - copy (yank)
    ["pp"] = "paste_from_clipboard",     -- ranger: pp - paste
    ["dd"] = "cut_to_clipboard",         -- ranger: dD - cut/move

    -- Directory navigation (ranger-style)
    ["<BS>"] = "navigate_up",            -- ranger: backspace - go up
    ["~"] = {                            -- ranger: ~ - go home
        function()
            require("neo-tree.command").execute({action="focus", source="filesystem", position="left", dir=vim.fn.expand("~")})
        end,
        desc = "Go to home directory"
    },

    -- View options (ranger-style)
    ["zh"] = "toggle_hidden",            -- ranger: zh - toggle hidden
    ["zf"] = "filter_on_submit",         -- ranger: zf - filter files
    ["zz"] = "clear_filter",             -- ranger: zz - clear filter

    -- Ranger-specific features
    ["i"] = "show_file_details",         -- ranger: i - file info
    ["<Space>"] = "toggle_node",         -- ranger: <Space> - select/mark
    ["v"] = "toggle_node",               -- ranger: v - select (visual)
    ["V"] = "expand_all_nodes",          -- ranger: V - select all (expand all as closest)
    -- Why tf does neotree override the / binding. smh. vscode users.
    ["/"] = {
        function()
            -- Start search mode in the neo-tree buffer
            vim.api.nvim_feedkeys("/", "n", false)
        end,
        desc = "Search in buffer"
    },
    ["f"] = "filter_on_submit",          -- ranger: f - filter files
    ["<C-f>"] = "filter_on_submit",      -- Alternative filter mapping

    ["r"] = "refresh",                   -- ranger: r - refresh
    ["R"] = "refresh",                   -- ranger: R - hard refresh

    -- System operations (ranger-style)
    -- aparently this is a netrw feature? surprised, doesn't seem like a very vim-like thing to have
    ["x"] = {                            -- ranger: x - execute
        function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
                vim.fn.jobstart({"xdg-open", node.path}, {detach = true})
            end
        end,
        desc = "Execute/open with system app"
    },

    -- Marks
    -- again, not a feature. now it is
    ["m"] = {
        function(state)
            local node = state.tree:get_node()
            local path = node.path
            
            -- Get single character for bookmark
            local char = vim.fn.getcharstr()
            if char:match("[a-zA-Z0-9]") then
                _G.neotree_bookmarks[char] = path
                local item_type = node.type == "file" and "file" or "directory"
                local name = vim.fn.fnamemodify(path, ":t")
                print("Bookmarked " .. item_type .. " '" .. name .. "' as '" .. char .. "'")
            else
                print("Invalid bookmark name (use a-z, A-Z, 0-9)")
            end
        end,
        desc = "Create bookmark (file or directory)"
    },
    ["'"] = {
        function(state)
            -- Get single character for bookmark to go to
            local char = vim.fn.getcharstr()
            local path = _G.neotree_bookmarks[char]
            
            if path then
                -- Check if bookmarked path still exists
                if vim.fn.isdirectory(path) == 1 or vim.fn.filereadable(path) == 1 then
                    -- Navigate to the bookmarked file/directory
                    require("neo-tree.command").execute({
                        action = "focus",
                        source = "filesystem",
                        position = "current",
                        reveal_file = path,
                    })
                    local name = vim.fn.fnamemodify(path, ":t")
                    print("Navigated to bookmark '" .. char .. "' (" .. name .. ")")
                else
                    print("Bookmark '" .. char .. "' no longer exists")
                    _G.neotree_bookmarks[char] = nil -- Clean up broken bookmark
                end
            else
                print("No bookmark set for '" .. char .. "'")
            end
        end,
        desc = "Go to bookmark"
    },
    ["`"] = {
        function(state)
            -- Same as ' but with backtick (ranger uses both)
            local char = vim.fn.getcharstr()
            local path = _G.neotree_bookmarks[char]
            
            if path then
                if vim.fn.isdirectory(path) == 1 or vim.fn.filereadable(path) == 1 then
                    require("neo-tree.command").execute({
                        action = "focus",
                        source = "filesystem",
                        position = "current", 
                        reveal_file = path,
                    })
                    local name = vim.fn.fnamemodify(path, ":t")
                    print("Navigated to bookmark '" .. char .. "' (" .. name .. ")")
                else
                    print("Bookmark '" .. char .. "' no longer exists")
                    _G.neotree_bookmarks[char] = nil
                end
            else
                print("No bookmark set for '" .. char .. "'")
            end
        end,
        desc = "Go to bookmark (backtick)"
    },

    -- Optional: Show all bookmarks
    ["<leader>m"] = {
        function()
            if next(_G.neotree_bookmarks) == nil then
                print("No bookmarks set")
                return
            end
            
            print("Bookmarks:")
            for char, path in pairs(_G.neotree_bookmarks) do
                local name = vim.fn.fnamemodify(path, ":t")
                local type_str = vim.fn.isdirectory(path) == 1 and "[DIR]" or "[FILE]"
                print("  " .. char .. " -> " .. type_str .. " " .. name)
            end
        end,
        desc = "List all bookmarks"
    },

    -- Close operations
    ["q"] = "close_window",              -- Close neotree
    ["ZZ"] = "close_window",             -- ranger: ZZ - quit ranger
    ["ZQ"] = "close_window",             -- ranger: ZQ - quit without saving

    -- Refresh (from netrw)
    ["<C-r>"] = "refresh",               -- Hard refresh
    ["<F5>"] = "refresh",                -- Alternative refresh

    -- Help
    ["?"] = "show_help",                 -- ranger: ? - help
    ["<F1>"] = "show_help",              -- netrw fallback: help

    -- Additional useful bindings (corrected)
    ["."] = "set_root",                  -- netrw: set current as root
    ["o"] = "open",                      -- netrw: open file (corrected)
    ["s"] = "open_split",                -- netrw: split (alternative)
    ["t"] = "open_tabnew",               -- netrw: tab (alternative)
}

require("neo-tree").setup{
    open_files_on_setup = false,
    event_handlers = {
        {
            event = "neo_tree_buffer_enter",
            handler = function(arg)
                vim.cmd [[ setlocal relativenumber ]]
            end,
        }
    },
    filesystem = {
        hijack_netrw_behavior = "disabled",
    },
    window = {
        mappings = my_nt_mappings
    },
}

vim.keymap.set("n", "<leader>nt", "<cmd>Neotree toggle<CR>", { noremap = true, silent = true })

-- bruh why no work with which-key by default, why ya gotta make your own binding system outside of nvim's that makes everything difficult. vscode users
local function generate_which_key_from_neotree(neotree_mappings, buffer)
    local wk_specs = {}

    for key, value in pairs(neotree_mappings) do
        local desc

        if type(value) == "table" and value.desc then
            -- Use existing description from mapping
            desc = "neo-tree: " .. value.desc
        elseif type(value) == "string" then
            -- Use the command name itself as description
            desc = "neo-tree: " .. value
        elseif type(value) == "function" then
            -- For functions, use a generic description
            desc = "neo-tree: " .. key
        end

        if desc then
            table.insert(wk_specs, {
                key,
                buffer = buffer,
                desc = desc
            })
        end
    end

    return wk_specs
end

-- Track registered buffers to prevent duplicates
local registered_buffers = {}

local prev_timeoutlen
vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        if vim.bo.filetype == "neo-tree" then
            prev_timeoutlen = vim.o.timeoutlen
            vim.o.timeoutlen = 999999999

            local buffer = vim.api.nvim_get_current_buf()

            -- Only register once per buffer to avoid duplicates
            if not registered_buffers[buffer] then
                local wk = require("which-key")
                local specs = generate_which_key_from_neotree(my_nt_mappings, buffer)

                -- Use the new which-key API
                wk.add(specs)

                registered_buffers[buffer] = true
            end
        end
    end,
})

vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        if vim.bo.filetype == "neo-tree" and prev_timeoutlen then
            vim.o.timeoutlen = prev_timeoutlen
        end
    end,
})

-- Clean up when buffer is deleted
vim.api.nvim_create_autocmd("BufDelete", {
    callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        registered_buffers[buffer] = nil
    end,
})

vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        if vim.bo.filetype == "neo-tree" and prev_timeoutlen then
            vim.o.timeoutlen = prev_timeoutlen
        end
    end,
})
