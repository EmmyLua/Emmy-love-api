local info = require 'metainfo'

---@return string
local function printer(metainfo)
    local returned = {}
    local function p(where, ...)
        table.insert(where, string.format(...))
    end
    for typename, def in pairs(metainfo) do
        local thisone = {}
        if type(def) == "string" then
            p(thisone, '---@alias %s %s', typename, def)
        else
            p(thisone, '---@class %s', typename)
            for fieldname, fieldtype in pairs(def) do
                p(thisone, '---@field %s %s', fieldname, info.stringify(fieldtype))
            end
        end
        p(returned, table.concat(thisone, '\n'))
    end
    return table.concat(returned, '\n\n')
end

print(printer(info.metainfo))