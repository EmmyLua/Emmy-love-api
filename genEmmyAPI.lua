
local api = require('love_api')

local function safeDesc(src)
    return string.gsub(src, "\n", "\n---")
end

local function genCorrectType(type)
    type = string.gsub(type, ' or ', '|')
    type = string.gsub(type, 'light userdata', 'userdata')
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
                    else
                        code = code .. gen_phrase('param', argument.description, argument.name, genCorrectType(argument.type))
                    end
                end
            else
                code = code .. gen_phrase('overload', variant.description, 
                    'fun('..
                        table.concat(map(
                            function(argu)
                                if argu.name == '...' then return '...' end
                                return argu.name..': '..genCorrectType(argu.type) end,
                            arguments), ', ')..'):'..
                        table.concat(map(
                            function(ret) return genCorrectType(ret.type) end,
                            variant.returns) or {'nil'}, ', '))
            end
        end

        if vIdx == 1 then
            if variant.returns and #variant.returns > 0 then
                for _, ret in ipairs(variant.returns) do
                    code = code .. gen_phrase('return', ret.description, genCorrectType(ret.type), ret.name)
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
    if type.parenttype then
        code = code .. ' : ' .. type.parenttype
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
    local code = '---' .. safeDesc(enum.description) .. '\n'
    code = code .. enum.name .. ' = {\n'
    for i, const in ipairs(enum.constants) do
        code = code .. '\t---' .. safeDesc(const.description) .. '\n'
        local name = const.name
        if name == '\\' then
            name = '\\\\'
        elseif name == '\'' then
            name = '\\\''
        end
        code = code .. '\t[\'' .. name .. '\'] = ' .. i .. ',\n'
    end
    code = code .. '}\n\n'
    return code
end

local function genModule(name, api)
    local f = assert(io.open("api/" .. name .. ".lua", 'w'))
    f:write("---@class " .. name .. '\n')
    if api.description then
        f:write('---' .. safeDesc(api.description) .. '\n\n')
    end
    f:write("local m = {}\n\n")

    -- types
    if api.types then
        for i, type in ipairs(api.types) do
            f:write('--region ' .. type.name .. '\n')
            f:write(genType(type.name, type))
            f:write('--endregion ' .. type.name .. '\n\n')
        end
    end

    -- enums
    if api.enums then
        for i, enum in ipairs(api.enums) do
            f:write(genEnum(enum))
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

    f:write("return m")
    f:close()
end

genModule('love', api)

print('--finished.')
