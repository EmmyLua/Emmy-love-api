--region printed
---@alias printed printed[]|string

---@param p printed
---@return string, number
local function printing(p)
    if type(p) == "string" then
        return p, 0
    end
    local subprinting, newlines = {}, 1
    for _, subprint in ipairs(p) do
        local new_sub, new_num = printing(subprint)
        table.insert(subprinting, new_sub)
        if new_num >= newlines then
            newlines = new_num + 1
        end
    end
    return table.concat(subprinting, string.rep('\n', newlines)), newlines
end

---@generic T
---@param f fun(t:T):printed
---@param mapped T[]
---@param added printed[]|nil
---@return printed
local function map_add(f, mapped, added)
    if added == nil then
        added = {}
    end
    local actual_added = {}
    local added_times = 0
    for _, t in ipairs(mapped) do
        table.insert(actual_added, f(t))
        added_times = added_times + 1
    end
    if added_times == 0 then
        return nil
    elseif added_times == 1 then
        if type(actual_added[1]) == 'string' then
            table.insert(added, actual_added[1])
        else
            for _, t in ipairs(actual_added[1]) do
                table.insert(added, t)
            end
        end
        return added
    else
        for _, t in ipairs(actual_added) do
            table.insert(added, t)
        end
        return added
    end
end

---@param p printed
---@return string[]
local function squash(p)
    local ret = {}
    if type(p) == 'string' then
        table.insert(ret, p)
    else
        for _, pi in ipairs(p) do
            for _, item in ipairs(squash(pi)) do
                table.insert(ret, item)
            end
        end
    end
    return ret
end

---@param printing printed
local function put(printed, printing, pos)
    if pos == nil then
        table.insert(printed, printing)
    else
        table.insert(printed, pos, printing)
    end
end
local function putf(printed,...)
    put(printed, string.format(...))
end

---@param description string
---@param without_first_dashes? boolean
---@return printed
local function gen_desc(description, without_first_dashes)
    local ret = {}
    for _ in description:gmatch("[^\n]*") do
        if without_first_dashes then
            table.insert(ret, _)
            without_first_dashes = false
        else
            table.insert(ret, '---'.._)
        end
    end
    return ret
end
--endregion printed

---@param type string
local function type_corrector(type)
    type = string.gsub(type, ' or ', '|')
    type = string.gsub(type, 'light userdata', 'userdata')
    if type:find('[^a-zA-Z0-9|_-]') then
        print('maybe wrong type: ' .. type)
        type = string.format("%q", type)
        print('quoted as: '..type)
    end
    return type
end

--region prelude
---@class field
---@field default string|nil
---@field description string
---@field type string

---@alias prelude table<string, table<string, field>>

---@param prelude prelude
---@param p printed[]
---@return printed
local function gen_prelude(prelude, p)
    local added = false
    for typename, fields in pairs(prelude) do
        local thisp = {}
        put(thisp, '---@class '..typename)
        for name, info in pairs(fields) do
            local desc = ' # '
            if info.default then
                desc = desc..'(default to '..info.default..') '
            end
            desc = desc..info.description
            if name ~= '...' then
                put(thisp, '---@field '..name..' '..type_corrector(info.type)..table.concat(gen_desc(desc, true), '\n'))
            else
                print('found ... in table definition '..typename)
                put(thisp, '------@field '..name..' '..type_corrector(info.type)..table.concat(gen_desc(desc, true), '\n'))
            end
        end
        put(p, thisp)
        added = true
    end
    if added then
        return p
    else
        return nil
    end
end

---@param prelude prelude
---@param t FunctionField[]
---@param gen_unique_name fun():string
---@param traceback string
---@return string typename
local function find_or_add(prelude, t, gen_unique_name, traceback)
    if t == nil then
        print('no field called table found at '..traceback)
        return 'table'
    end
    local actual_fields = {}
    for _, field in pairs(t) do
        actual_fields[field.name] = {
            type=field.type == 'table' and find_or_add(prelude, field.table, gen_unique_name, traceback..'.'..field.name) or field.type,
            default=field.default,
            description=field.description
        }
    end
    local actual_length = #actual_fields
    for typename, fields in pairs(prelude) do
        if (function()
            if #fields ~= actual_length then return end
            for fieldname, fieldinfo in pairs(fields) do
                local actualinfo = actual_fields[fieldname]
                if not actualinfo then return end
                if fieldinfo.default ~= actualinfo.default then return end
                if fieldinfo.description ~= actualinfo.description then return end
                if fieldinfo.type ~= actualinfo.type then return end
            end
            return true
        end)() then
            return typename
        end
    end
    local name = gen_unique_name()
    prelude[name] = actual_fields
    return name
end

---@param items FunctionField[]
---@param prelude prelude
---@param gen_unique_name fun():string
---@param traceback string
---@return fun():FunctionField|nil
local function expand_items(items, prelude, gen_unique_name, traceback)
    local k = 1
    local temp = nil
    return function()
        if not items then return end
        if temp then
            local t = temp()
            if t ~= nil then return t end
            temp = nil
        end
        local item = items[k]
        k = k + 1
        if not item then return end
        local typename = item.type
        if typename == 'table' then
            typename = find_or_add(prelude, item.table, gen_unique_name, traceback..'['..(k-1)..']')
        else
            typename = type_corrector(typename)
        end
        local function get_returned(name)
            return {
                type=typename,
                name=name,
                default=item.default,
                description=item.description
            }
        end
        if not item.name:find(',') then return get_returned(item.name) end
        local names = item.name:gmatch('[^ ,]+')
        function temp()
            local name = names()
            if not name then return end
            return get_returned(name)
        end
        return temp()
    end
end
--endregion prelude


--region api-definition
---@class EnumConstant
---@field name string
---@field description string

---@class OneFunction
---@field returns FunctionField[]|nil
---@field description string|nil
---@field arguments FunctionField[]|nil

---@alias Callback Function

---@class Love
---@field types Type[]
---@field version string
---@field functions Function[]
---@field callbacks Callback[]
---@field modules Module[]

---@class Type
---@field supertypes string[]|nil
---@field name string
---@field description string
---@field constructors string[]|nil
---@field functions Function[]|nil

---@class Enum
---@field name string
---@field description string
---@field constants EnumConstant[]

---@class Function
---@field name string
---@field description string
---@field variants OneFunction[]

---@class FunctionField
---@field type string
---@field table FunctionField[]|nil
---@field default string|nil
---@field name string
---@field description string

---@class Module
---@field types Type[]
---@field name string
---@field description string
---@field functions Function[]
---@field enums Enum[]
--endregion api-definition


WHERE='api/%s.lua'

---@param prelude prelude
---@param prefix string
local function gen_function(prelude, prefix)
    -- use a bug(?) in the language server that '-' is allowed in type name
    local prelude_prefix = prefix:gsub('[.:]', '-')
    ---@param func Function
    ---@return printed
    return function(func)
        local prelude_counter = 0
        local actual_prefix = prelude_prefix..func.name..'-'
        local function gen_unique_name()
            prelude_counter = prelude_counter + 1
            return actual_prefix..prelude_counter
        end
        return map_add(function(variant)
            local desc = func.description
            if variant.description then
                desc = desc .. '\n' .. variant.description
            end
            local variantp = gen_desc(desc)
            local parameter_list = {}
            for argument in expand_items(variant.arguments, prelude, gen_unique_name, prefix..func.name..':parameters') do
                table.insert(parameter_list, argument.name)
                local printed = {}
                if argument.name == '...' then
                    put(printed, '---@vararg')
                else
                    put(printed, '---@param')
                    if argument.default then
                        put(printed, argument.name..'?')
                    else
                        put(printed, argument.name)
                    end
                end
                put(printed, argument.type)
                put(printed, '@')
                if argument.default then
                    put(printed, '(default to '..argument.default..')')
                end
                put(printed, table.concat(gen_desc(argument.description, true), '\n'))
                put(variantp, table.concat(printed, ' '))
            end
            for returned in expand_items(variant.returns, prelude, gen_unique_name, prefix..func.name..':returns') do
                local printed = {}
                put(printed, '---@return')
                put(printed, returned.type)
                put(printed, returned.name)
                put(printed, '@')
                if returned.default then
                    put(printed, '(default to '..returned.default..')')
                end
                put(printed, table.concat(gen_desc(returned.description, true), '\n'))
                put(variantp, table.concat(printed, ' '))
            end
            put(variantp, 'function '..prefix..func.name..'('..table.concat(parameter_list, ', ')..') end')
            return squash(variantp)
        end, func.variants)
    end
end

---@param prelude prelude
---@param prefix string
local function gen_callback(prelude, prefix)
    return gen_function(prelude, prefix)
end

---@param prelude prelude
local function gen_type(prelude)
    ---@param type Type
    ---@return printed
    return function(type)
        local p = {'--region '..type.name}
        local header = gen_desc(type.description)
        local type_decl = '---@class '..type.name
        if type.supertypes then
            type_decl = type_decl..': '..table.concat(type.supertypes, ', ')
        end
        put(header, type_decl)
        put(header, 'local '..type.name..' = {}')
        put(p, header)
        map_add(gen_function(prelude, type.name..':'), type.functions, p)
        put(p, '--endregion '..type.name)
        return p
    end
end

---@param enum_constant EnumConstant
---@return printed
local function gen_enum_constant(enum_constant)
    local p = gen_desc(enum_constant.description)
    putf(p, '---| %q', "'"..enum_constant.name.."'")
    return p
end

---@param enum Enum
---@return printed
local function gen_enum(enum)
    local p = gen_desc(enum.description)
    put(p, '---@alias '..enum.name)
    put(p, map_add(gen_enum_constant, enum.constants))
    return squash(p)
end

---@param module Module
---@return printed
local function gen_write_module(module)
    local p = {}
    local header = gen_desc(module.description)
    table.insert(header, 'local '..module.name..' = {}')
    put(p, header)
    local prelude = {}
    put(p, map_add(gen_type(prelude), module.types, {'-- types'}))
    put(p, map_add(gen_function(prelude, module.name..'.'), module.functions, {'-- functions'}))
    put(p, map_add(gen_enum, module.enums, {'-- enums'}))
    put(p, gen_prelude(prelude, {'-- preludes'}))
    put(p, 'return '..module.name)
    local f = assert(io.open(string.format(WHERE, 'love/'..module.name), 'w'))
    p, _ = printing(p)
    f:write(p)
    f:close()
    return string.format('love.%s = require "love/%s"', module.name, module.name)
end

---@param love Love
local function gen_write_love(love)
    local p = {}
    put(p, 'local love = {}')
    putf(p, 'love.version = %q', love.version)
    local prelude = {}
    put(p, map_add(gen_function(prelude, 'love.'), love.functions, {'-- functions'}))
    put(p, map_add(gen_write_module, love.modules, {'-- modules'}))
    put(p, map_add(gen_type(prelude), love.types, {'-- types'}))
    put(p, map_add(gen_callback(prelude, 'love.'), love.callbacks, {'-- callbacks'}))
    put(p, gen_prelude(prelude, {'-- preludes'}))
    put(p, 'return love')
    put(p, '---@alias Variant table|boolean|string|number|Object')
    local f = assert(io.open(string.format(WHERE, 'love'), 'w'))
    p, _ = printing(p)
    f:write(p)
    f:close()
end


gen_write_love(require 'love_api')
