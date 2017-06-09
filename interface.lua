local interface

local function satisfy(iface, class)
    assert(iface, "interface must not be nil")
    assert(class, "class must not be nil")
    for _, name in ipairs(iface.methods) do
        local m = class[name]
        assert(m, "Field is nil: " .. name)
        local t = type(m)
        assert(t == "function", "Field is not a method: " .. name)
    end
end

function interface(methods)
    local iface = { methods = methods }
    iface.satisfy = satisfy
    return iface
end

return interface
