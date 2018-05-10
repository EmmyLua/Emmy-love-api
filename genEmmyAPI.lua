
local api = require('love_api')

local function safeDesc(src)
    return string.gsub(src, "\n", "\n---")
end

local function genReturns(variant)
    local returns = variant.returns
    local s = ""
    local num = 0
    if returns and #returns > 0 then
        num = #returns
        for i, ret in ipairs(returns) do
            if i == 1 then
                s = ret.type
            else
                s = s .. ', ' .. ret.type
            end
        end
    else
        s = "void"
    end
    return s, num
end

local function genFunction(moduleName, fun, static)
    local code = "---" .. safeDesc(fun.description) .. "\n"
    local argList = ''

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
                    code = code .. '---@param ' .. argument.name .. ' ' .. argument.type .. ' @' .. argument.description .. '\n'
                end
            else
                code = code .. '---@overload fun('
                for argIdx, argument in ipairs(arguments) do
                    if argIdx == 1 then
                        code = code .. argument.name .. ':' .. argument.type
                    else
                        code = code .. ', '
                        code = code .. argument.name .. ':' .. argument.type
                    end
                end
                code = code .. '):' .. genReturns(variant)
                code = code .. '\n'
            end
        end

        if vIdx == 1 then
            local type, num = genReturns(variant)
            if num > 0 then
                code = code .. '---@return ' .. type .. '\n'
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

    return code
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
    code = code .. '}\n'
    return code
end

local function genModule(name, api)
    local f = io.open("api/" .. name .. ".lua", 'w')
    f:write("---@class " .. name .. '\n')
    if api.description then
        f:write('---' .. safeDesc(api.description) .. '\n')
    end
    f:write("local m = {}\n\n")

    -- types
    if api.types then
        for i, type in ipairs(api.types) do
            f:write('--region ' .. type.name .. '\n')
            f:write(genType(type.name, type))
            f:write('--endregion ' .. type.name .. '\n')
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