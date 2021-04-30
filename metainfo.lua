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

return {
    metainfo = metainfo,
    stringify = stringify
}