local class   = require "class"
local testing = require "testing"

local t = {}

function t:test_instance()
    local Point = class {}
    local p = Point.new()
    assert(p)
end

function t:test_eq()
    local Point = class {}
    local p1 = Point.new()
    local p2 = Point.new()
    assert(p1 ~= p2)
end

function t:test_assign()
    local Point = class {}
    local p1 = Point.new()
    local p2 = Point.new()
    p1.x = 1
    p2.x = 2
    assert(p1.x == 1)
    assert(p2.x == 2)
end

return t
