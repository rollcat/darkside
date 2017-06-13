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

function t:test_recursive_runner()
    local runner = testing.TestRunner:new {
        logger = testing.NullLogger,
        tests = {
            test_recursive_runner = {
                test_pass = function() end,
                test_skip = function() testing.skip() end,
                test_fail = function() error("fail") end,
            },
        }
    }
    runner:run()
    assert(#runner.totals.ok == 1)
    assert(#runner.totals.skip == 1)
    assert(#runner.totals.fail == 1)
end

return t
