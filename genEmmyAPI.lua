
local api = require('love_api')

local function safeDesc(src)
    return string.gsub(src, "\n", "\n---")
end

local function genCorrectType(type)
    type = string.gsub(type, ' or ', '|')
    type = string.gsub(type, 'light userdata', 'userdata')
    if type:find("'") then
        type = '"'..type..'"'
    end
    if type:find(' ') then
        print('maybe wrong type: ' .. type)
    end
    return type
end

local function genFunction(moduleName, fun, static)
    local code = "---" .. safeDesc(fun.description) .. "\n"
    local argList = ''

    local function gen_phrase(code, comment, ...)
        local res = {'---@'..code, ...}
        if comment ~= nil then
            table.insert(res, '@'..safeDesc(comment))
        end
        return table.concat(res, ' ') .. '\n'
    end

    local function map(f, xs)
        if xs == nil then return nil end
        local res = {}
        for _, v in ipairs(xs) do
            table.insert(res, f(v))
        end
        return res
    end


    for vIdx, variant in ipairs(fun.variants) do
        -- args
        local arguments = variant.arguments
        if arguments and #arguments > 0 then
            if vIdx == 1 then
                for argIdx, argument in ipairs(arguments) do
                    if argIdx == 1 then
                        argList = argument.name
                    else
                        argList = argList .. ', ' .. argument.name
                    end
                    if argument.name == '...' then
                        code = code .. gen_phrase('vararg', argument.description, genCorrectType(argument.type))
                    elseif argument.name:find(',') then
                        for name in argument.name:gmatch('[^, ]+') do
                            code = code .. gen_phrase('param', argument.description, name, genCorrectType(argument.type))
                        end
                    else
                        code = code .. gen_phrase('param', argument.description, argument.name, genCorrectType(argument.type))
                    end
                end
            else
                code = code .. gen_phrase('overload', variant.description, 
                    'fun('..table.concat(map(
                        function(argu)
                            if argu.name == '...' then
                                return '...'
                            elseif argu.name:find(',') then
                                local ret = ''
                                local printed = false
                                for name in argu.name:gmatch('[^ ,]+') do
                                    if printed then
                                        ret = ret..', '
                                    end
                                    ret = ret..name..': '..genCorrectType(argu.type)
                                    printed = true
                                end
                                return ret
                            else
                                return argu.name..': '..genCorrectType(argu.type)
                            end
                        end,
                        arguments), ', ')..
                    '):'..table.concat(map(
                        function(ret) return genCorrectType(ret.type) end,
                        variant.returns) or {'nil'}, ', '))
            end
        end

        if vIdx == 1 then
            if variant.returns and #variant.returns > 0 then
                for _, ret in ipairs(variant.returns) do
                    if ret.name:find(',') then
                        for name in ret.name:gmatch('[^ ,]+') do
                            code = code .. gen_phrase('return', ret.description, genCorrectType(ret.type), name)
                        end
                    else
                        code = code .. gen_phrase('return', ret.description, genCorrectType(ret.type), ret.name)
                    end
                end
            else
                code = code .. gen_phrase('return', nil, 'nil')
            end
        end
    end

    local dot = static and '.' or ':'
    code = code .. "function " .. moduleName .. dot .. fun.name .. "(" .. argList .. ") end\n\n"
    return code
end

local function genType(name, type)
    local code = "---@class " .. type.name
    if type.supertypes then
        code = code .. ' : '
        local printed = false
        for _, typename in ipairs(type.supertypes) do
            if printed then
                code = code .. ', '
            end
            code = code .. typename
            printed = true
        end
    end
    code = code .. '\n'
    code = code .. '---' .. safeDesc(type.description) .. '\n'
    code = code .. 'local ' .. name ..  ' = {}\n'
    -- functions
    if type.functions then
        for i, fun in ipairs(type.functions) do
            code = code .. genFunction(name, fun, false)
        end
    end

    return code .. '\n\n'
end

local function genEnum(enum)
    local code = '---#' .. safeDesc(enum.description) .. '\n'
    code = code..'---@alias '..enum.name..'\n'
    for _, const in ipairs(enum.constants) do
        code = code..'---| "\''..const.name..'\'"'
        if const.description then
            code = code..' #'..string.gsub(const.description, '\n', '  ')
        end
        code = code..'\n'
    end
    return code..'\n'
end

local function genModule(name, api)
    local f = assert(io.open("api/" .. name .. ".lua", 'w'))
    f:write("---@class " .. name .. '\n')
    if api.description then
        f:write('---' .. safeDesc(api.description) .. '\n\n')
    end
    f:write("local m = {}\n\n")

    -- enums
    if api.enums then
        for i, enum in ipairs(api.enums) do
            f:write(genEnum(enum))
        end
    end

    -- types
    if api.types then
        for i, type in ipairs(api.types) do
            f:write('--region ' .. type.name .. '\n')
            f:write(genType(type.name, type))
            f:write('--endregion ' .. type.name .. '\n\n')
        end
    end

    -- modules
    if api.modules then
        for i, m in ipairs(api.modules) do
            f:write("---@type " .. name .. '.' .. m.name .. '\n')
            f:write("m." .. m.name .. ' = nil\n\n')
            genModule(name .. '.' .. m.name, m)
        end
    end

    -- functions
    for i, fun in ipairs(api.functions) do
        f:write(genFunction('m', fun, true))
    end

    -- callbacks
    if api.callbacks then
        for i, fun in ipairs(api.callbacks) do
            f:write(genFunction('m', fun, true))
        end
    end

    f:write("return m")
    f:close()
end

genModule('love', api)

print('--finished.')
