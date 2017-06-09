local testing = require "testing"

local t = {}

function t:test_skip()
    testing.skip()
end

function t:test_pass()
    testing.pass()
    error("not reached")
end

return t
