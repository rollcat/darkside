local class = function(fields)
    local cls = {}
    fields = fields or {}
    cls.extend = function(cls, fields)
        for k, v in pairs(fields) do
            cls[k] = v
        end
        return cls
    end
    cls:extend(fields)
    function cls.new(args)
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
    return cls
end

return class
