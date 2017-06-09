local testing = require "testing"

local t = {}

function t:test_skip()
    testing.skip()
end

function t:test_pass()
    testing.pass()
    error("not reached")
end

function t:test_must_fail()
    local ran = false
    testing.must_fail(
        function()
            ran = true
            error()
        end
    )
    assert(ran)
end

return t
