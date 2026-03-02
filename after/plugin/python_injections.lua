-- Extend Python treesitter injection queries to support comment annotations:
--
--   # tree-sitter-language: <lang>
--   # tree-sitter-injection: <lang>
--
-- Works on bare string expressions and assignment RHS strings.

local custom = [[
((comment) @injection.language
 . (expression_statement
     (string (string_content) @injection.content))
 (#lua-match? @injection.language "^#%s*tree%-sitter%-")
 (#gsub! @injection.language "^#%s*tree%-sitter%-[%a%-]+:%s*" ""))

((comment) @injection.language
 . (expression_statement
     (assignment
       right: (string (string_content) @injection.content)))
 (#lua-match? @injection.language "^#%s*tree%-sitter%-")
 (#gsub! @injection.language "^#%s*tree%-sitter%-[%a%-]+:%s*" ""))
]]

local parts = {}
for _, f in ipairs(vim.api.nvim_get_runtime_file('queries/python/injections.scm', true)) do
    local fh = io.open(f)
    if fh then
        parts[#parts + 1] = fh:read('*a')
        fh:close()
    end
end
parts[#parts + 1] = custom

vim.treesitter.query.set('python', 'injections', table.concat(parts, '\n'))
