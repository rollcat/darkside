local class

local function inherit(base, fields)
    assert(base, "inherit must be called with a class as first argument")
    subcls = class(base)
    for k, v in pairs(fields) do
        subcls[k] = v
    end
    return subcls
end

local function new(cls, args)
    assert(cls, "new must be called with a class as first argument")
    local self = {}
    args = args or {}
    setmetatable(self, {__index=cls})
    if self.init then
        self:init(args)
    else
        for k, v in pairs(args) do
            assert(cls[k])
            self[k] = v
        end
    end
    self.cls = cls
    return self
end

class = function(fields)
    local cls = {
        new     = new,
        inherit = inherit,
    }
    fields = fields or {}
    for k, v in pairs(fields) do
        cls[k] = v
    end
    return cls
end

return class
