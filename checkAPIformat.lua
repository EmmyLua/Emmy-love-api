---@class my_nullable
---@field name "'nullable'"
---@field wrapped my_type

---@class my_many
---@field name "'many'"
---@field wrapped my_type

---@alias my_type my_nullable|my_many|string

---@param type my_type
---@return my_nullable
local function optional(type)
    return {
        name='nullable',
        wrapped=type
    }
end

---@param type my_type
---@return my_many
local function array(type)
    return {
        name='many',
        wrapped=type
    }
end

---@param Type my_type
---@return string
local function stringify(Type)
    if type(Type) == 'string' then
        return Type
    else
        assert(type(Type) == 'table')
        if Type.name == 'nullable' then
            return stringify(Type.wrapped)..'|nil'
        elseif Type.name == 'many' then
            return stringify(Type.wrapped)..'[]'
        else
            assert(false, 'illegal type')
        end
    end
end

-- generated from EmmyLua in `genEmmyAPI.lua`
local metainfo = {
    Love={
        version="string",
        functions=array("Function"),
        modules=array("Module"),
        types=array("Type"),
        callbacks=array("Callback"),
    },
    Module={
        name="string",
        description="string",
        types=array("Type"),
        functions=array("Function"),
        enums=array("Enum"),
    },
    Enum={
        name="string",
        description="string",
        constants=array("EnumConstant"),
    },
    EnumConstant={
        name="string",
        description="string",
    },
    Type={
        name="string",
        description="string",
        constructors=optional(array("string")),
        functions=optional(array("Function")),
        supertypes=optional(array("string")),
    },
    Callback="Function",
    Function={
        name="string",
        description="string",
        variants=array("OneFunction"),
    },
    OneFunction={
        returns=optional(array("FunctionField")),
        arguments=optional(array("FunctionField")),
        description=optional("string"),
    },
    FunctionField={
        type="string",
        name="string",
        default=optional("string"),
        description="string",
        table=optional(array("FunctionField")),
    },
}

---@param obj any
---@param Type my_type
---@param prefix string|nil
---@return boolean ok
local function check(obj, Type, prefix)
    local ok = true
    local function fail_match(expected, got)
        print('<'..prefix..'>: expected '..expected..', but got '..got)
        return false
    end
    if prefix == nil then
        prefix = ''
    end
    if type(Type) == 'table' then
        if Type.name == 'nullable' then
            if obj ~= nil then
                ok = ok and check(obj, Type.wrapped, prefix..'?')
            end
        elseif Type.name == 'many' then
            if type(obj) ~= "table" then
                return fail_match(stringify(Type), type(obj))
            end
            for key, value in pairs(obj) do
                if type(key) ~= "number" then
                    print('<'..prefix..'>: nonnumeric key', key)
                    ok = false
                else
                    ok = ok and check(value, Type.wrapped, prefix..'['..key..']')
                end
            end
        else
            assert(false, 'illegal type')
        end
    elseif Type == 'string' then
        if type(obj) ~= 'string' then
            return fail_match('string', type(obj))
        end
    else
        local info = assert(metainfo[Type])
        if type(info) == 'string' then
            return check(obj, info, prefix)
        end
        if type(obj) ~= "table" then
            return fail_match(stringify(Type), type(obj))
        end
        local need_to_be_checked = {}
        for k, v in pairs(info) do
            need_to_be_checked[k] = v
        end
        for k, v in pairs(obj) do
            if not info[k] then
                print('<'..prefix..'>: extra field '..k ..' and value '..type(v))
                ok = false
            else
                ok = ok and check(v, info[k], prefix..'.'..k)
                need_to_be_checked[k] = nil
            end
        end
        for k, v in pairs(need_to_be_checked) do
            ok = ok and check(nil, v, prefix..'.'..k)
        end
    end
    return ok
end

---@return string
local function printer()
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
                p(thisone, '---@field %s %s', fieldname, stringify(fieldtype))
            end
        end
        p(returned, table.concat(thisone, '\n'))
    end
    return table.concat(returned, '\n\n')
end

assert(check(require 'love_api', 'Love', 'love'))
print(printer())
