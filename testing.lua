require "string_extra"

function skip()
    error("skip", 0)
end

function pass()
    error("pass", 0)
end

function must_fail(f, ...)
    local ok = pcall(f, ...)
    if ok then error("Did not fail", 2) end
end


local TestTotals = {}
function TestTotals.new()
    this = {
        ok   = {},
        skip = {},
        fail = {},
    }
    function this:log_result(name, ok, err)
        if ok or err == "pass" then
            table.insert(self.ok, name)
        elseif err == "skip" then
            table.insert(self.skip, name)
        else
            table.insert(self.fail, {name=name, err=err})
        end
    end
    function this:print_result()
        local s = string.format(
            "totals: OK=%d skip=%s fail=%s",
            #self.ok,
            #self.skip,
            #self.fail
        )
        print(s)
    end
    function this:status()
        if #self.fail == 0 then
            return 0
        else
            return 1
        end
    end
    return this
end


local VerboseLogger = {}
function VerboseLogger:log_start(...)
    print(...)
end
function VerboseLogger:log_result(name, ok, err)
    if ok or err == "pass" then
        print("ok:", name)
    elseif err == "skip" then
        print("skip:", name)
    else
        print("fail:", name, err)
    end
end
function VerboseLogger:log_totals(totals)
    totals:print_result()
end

local QuietLogger = {}
function QuietLogger:log_start(...) end
function QuietLogger:log_result(name, ok, err)
    if ok or err == "pass" then
        io.write(".")
    elseif err == "skip" then
        io.write("S")
    else
        io.write("F")
    end
end
function QuietLogger:log_totals(totals)
    io.write("\n")
    for _, t in ipairs(totals.fail) do
        print("fail:", t.name, t.err)
    end
    totals:print_result()
end


local TestRunner = {}
function TestRunner.new(args)
    this = {
        totals = TestTotals.new(),
        tests  = assert(args.tests),
        logger = args.logger or QuietLogger,
    }
    function this:test_module(modname, mod)
        for xname, value in pairs(mod) do
            if xname:startswith("test_") and type(value) == "function" then
                self:test_function(modname, mod, xname, value)
            end
        end
    end
    function this:test_function(modname, mod, fname, f)
        local name = modname .. ":" .. fname
        self.logger:log_start("test:", name)
        local ok, err = pcall(function() return f(mod) end)
        self.logger:log_result(name, ok, err)
        self.totals:log_result(name, ok, err)
    end
    function this:run()
        for name, mod in pairs(self.tests) do
            self:test_module(name, mod)
        end
        self.logger:log_totals(self.totals)
    end
    return this
end


return {
    QuietLogger   = QuietLogger,
    TestRunner    = TestRunner,
    TestTotals    = TestTotals,
    VerboseLogger = VerboseLogger,
    must_fail     = must_fail,
    pass          = pass,
    skip          = skip,
}
