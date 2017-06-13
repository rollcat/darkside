local class   = require "class"
local testing = require "testing"

local t = {}

function t:test_instance()
    local Point = class {}
    local p = Point:new()
    assert(p)
end

function t:test_eq()
    local Point = class {}
    local p1 = Point:new()
    local p2 = Point:new()
    assert(p1 ~= p2)
end

function t:test_assign()
    local Point = class {}
    local p1 = Point:new()
    local p2 = Point:new()
    p1.x = 1
    p2.x = 2
    assert(p1.x == 1)
    assert(p2.x == 2)
end

function t:test_cls_defaults()
    local Cat = class {
        sound = "meow",
    }
    function Cat:say() return self.sound end
    assert(Cat.sound == "meow")
    assert(Cat:new().sound == "meow")
    assert(Cat:say() == "meow")
    assert(Cat:new():say() == "meow")
    local cat = Cat:new()
    cat.sound = "mrr"
    assert(Cat.sound == "meow")
    assert(Cat:new().sound == "meow")
    assert(cat:say() == "mrr")
end

function t:test_cls_inline_function()
    local Cat = class {
        sound = "meow",
        say = function(self) return self.sound end,
    }
    assert(Cat.sound == "meow")
    assert(Cat:new().sound == "meow")
    assert(Cat:say() == "meow")
    assert(Cat:new():say() == "meow")
end

function t:test_inheritance_slurp()
    local Animal = class {
        sound = "",
        say = function(self) return self.sound end,
    }
    local Cat = class(Animal)
    Cat.sound = "meow"
    assert(Animal.sound == "")
    assert(Animal:new().sound == "")
    assert(Animal:say() == "")
    assert(Animal:new():say() == "")
    assert(Cat.sound == "meow")
    assert(Cat:new().sound == "meow")
    assert(Cat:say() == "meow")
    assert(Cat:new():say() == "meow")
end

function t:test_inheritance_inherit()
    local Animal = class {
        sound = "",
        say = function(self) return self.sound end,
    }
    local Cat = Animal:inherit {
        sound = "meow",
    }
    assert(Animal.sound == "")
    assert(Animal:new().sound == "")
    assert(Animal:say() == "")
    assert(Animal:new():say() == "")
    assert(Cat.sound == "meow")
    assert(Cat:new().sound == "meow")
    assert(Cat:say() == "meow")
    assert(Cat:new():say() == "meow")
end

function t:test_inheritance_custom_new()
    local Animal = class {
        sound = "",
        say = function(self) return self.sound end,
    }
    local Cat = Animal:inherit {}
    Cat.new = function(cls, args)
        self = {}
        self.say = function(self) return "meow" end
        return self
    end
    assert(Animal:new():say() == "")
    assert(Cat:new():say() == "meow")
end

function t:test_inheritance_custom_inherit()
    local Animal = class {
        sound = "",
        say = function(self) return self.sound end,
    }
    local Cat = Animal:inherit {
        sound = "meow",
    }
    Cat.inherit = function(base, fields)
        subcls = class(base)
        subcls.base = Cat
        for k, v in pairs(fields) do
            subcls[k] = v
        end
        return subcls
    end
    local Tiger = Cat:inherit {
        sound = "ROAR",
    }
    assert(Animal:new():say() == "")
    assert(Cat:new():say() == "meow")
    assert(Tiger:new():say() == "ROAR")
    assert(Tiger.base == Cat)
end

return t
