local class     = require "class"
local interface = require "interface"

local testing = require "testing"

local t = {}

function t:test_any()
    local IAny = interface {}
    IAny:satisfy({})
    local Movie = class {}
    IAny:satisfy(Movie)
end

function t:test_one_method()
    local ISayer = interface {
        "say",
    }
    local Jay = class {
        say = function(self) return "yo" end,
    }
    local SilentBob = class {}
    ISayer:satisfy(Jay)
    testing.must_fail(
        function()
            ISayer:satisfy(SilentBob)
        end
    )
end

function t:test_two_methods()
    local ISmoker = interface {
        "smoke",
    }
    local ISaySmoker = interface {
        "say",
        "smoke",
    }
    local Jay = class {
        say = function(self) return "yo" end,
        smoke = function(self) return "puff" end,
    }
    local SilentBob = class {
        smoke = function(self) return "puff" end,
    }
    ISmoker:satisfy(Jay)
    ISaySmoker:satisfy(Jay)
    testing.must_fail(
        function()
            ISaySmoker:satisfy(SilentBob)
        end
    )
    ISmoker:satisfy(SilentBob)
end

function t:test_not_method()
    local ISayer = interface {
        "say",
    }
    local Jay = class {
        say = function(self) return "yo" end,
    }
    local SilentBob = class {
        say = "<not actually saying anything>",
    }
    ISayer:satisfy(Jay)
    testing.must_fail(
        function()
            ISayer:satisfy(SilentBob)
        end
    )
end

return t
