---@class my_nullable
---@field name 'nullable'
---@field wrapped my_type

---@class my_many
---@field name 'many'
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
        return string
    else
        assert(type(Type) == 'table')
        if Type.name == 'nullable' then
            return stringify(Type.wrapped)..'?'
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
        callbacks=array("Function"),
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
local function check(obj, Type, prefix)
    local function match(expected, got)
        print('<'..prefix..'>: expected '..expected..', but got '..got)
    end
    if prefix == nil then
        prefix = ''
    end
    if type(Type) == 'table' then
        if Type.name == 'nullable' then
            if obj ~= nil then
                check(obj, Type.wrapped, prefix..'?')
            end
        elseif Type.name == 'many' then
            if type(obj) ~= "table" then
                match(stringify(Type), type(obj))
                return
            end
            for key, value in pairs(obj) do
                if type(key) ~= "number" then
                    print('<'..prefix..'>: nonnumeric key', key)
                else
                    check(value, Type.wrapped, prefix..'['..key..']')
                end
            end
        else
            assert(false, 'illegal type')
        end
    elseif Type == 'string' then
        if type(obj) ~= 'string' then
            match('string', type(obj))
            return
        end
    else
        if type(obj) ~= "table" then
            match(stringify(Type), type(obj))
            return
        end
        local info = assert(metainfo[Type])
        local need_to_be_checked = {}
        for k, v in pairs(info) do
            need_to_be_checked[k] = v
        end
        for k, v in pairs(obj) do
            if not info[k] then
                print('<'..prefix..'>: extra field '..k ..' and value '..type(v))
            else
                check(v, info[k], prefix..'.'..k)
                need_to_be_checked[k] = nil
            end
        end
        for k, v in pairs(need_to_be_checked) do
            check(nil, v, prefix..'.'..k)
        end
    end
end

check(require 'love_api', 'Love', 'love')