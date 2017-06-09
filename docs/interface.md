# `interface.lua`

Interfaces are defined using a table, listing the method names that
must be implemented:

`IMyFoo.lua`:

```lua
local interface = require "interface"
local IMyFoo = interface {
    "foo",
}
return IMyFoo
```

Classes can declare that they implement interfaces:

`MyClass.lua`:

```lua
local class = require "class"
local IMyFoo = require "IMyFoo"
local MyClass = class {
    x = 1,
}
function MyClass:foo()
    return self.x
end
IMyFoo.satisfy(MyClass)  -- would error if MyClass.foo were not a function
return MyClass
```

Functions can assert that their arguments implement interfaces:

```lua
function frobnicate(f, g)
    IMyFoo:satisfy(f)
    return f.foo() + g
end
```
