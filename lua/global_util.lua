local function serialize(val, indent, visited_stack)
    indent = indent or ""
    visited_stack = visited_stack or {}

    local function path_to(val)
        for _, v in ipairs(visited_stack) do
            if v.val == val then
                return v.path
            end
        end
        return nil
    end

    if type(val) == "table" then
        local existing = path_to(val)
        if existing then
            return string.format('"<circular reference via %s>"', existing)
        end

        local lines = {"{"}
        table.insert(visited_stack, { val = val, path = "(root)" })

        for k, v2 in pairs(val) do
            local keystr
            if type(k) == "string" then
                keystr = string.format("%q", k)
            else
                keystr = tostring(k)
            end

            visited_stack[#visited_stack].path = visited_stack[#visited_stack].path .. " -> [" .. keystr .. "]"
            table.insert(lines, indent .. "  [" .. keystr .. "] = " .. serialize(v2, indent .. "  ", visited_stack))
            visited_stack[#visited_stack].path = visited_stack[#visited_stack].path:gsub(" -> %[" .. keystr:gsub("([^%w])", "%%%1") .. "%]$", "")
        end

        table.remove(visited_stack)
        table.insert(lines, indent .. "}")
        return table.concat(lines, "\n")

    elseif type(val) == "string" then
        return string.format("%q", val)
    else
        return tostring(val)
    end
end

function _G.PSTR(v)
    return serialize(v)
end

function _G.PPRINT(v)
    print(serialize(v))
    return v
end

function _G.PNOTIFY(v)
    vim.notify(serialize(v))
    return v
end
