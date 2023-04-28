local info = require 'metainfo'

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
                return fail_match(info.stringify(Type), type(obj))
            end
            if Type.num then
                if #obj ~= Type.num then
                    print('<'..prefix..'>: expected '..Type.num..' elements, but got '..#obj)
                    ok = false
                end
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
        local typeinfo = assert(info.metainfo[Type])
        if type(typeinfo) == 'string' then
            return check(obj, typeinfo, prefix)
        end
        if type(obj) ~= "table" then
            return fail_match(info.stringify(Type), type(obj))
        end
        local need_to_be_checked = {}
        for k, v in pairs(typeinfo) do
            need_to_be_checked[k] = v
        end
        for k, v in pairs(obj) do
            if not typeinfo[k] then
                print('<'..prefix..'>: extra field '..k ..' and value '..type(v))
                ok = false
            else
                ok = ok and check(v, typeinfo[k], prefix..'.'..k)
                need_to_be_checked[k] = nil
            end
        end
        for k, v in pairs(need_to_be_checked) do
            ok = ok and check(nil, v, prefix..'.'..k)
        end
    end
    return ok
end

assert(check(require 'love-api/love_api', 'Love', 'love'))
