# `class.lua`

## Define

Classes can be defined like so:

```lua
local class = require "class"
local MyClass = class {
    -- static field / default value definitions,
    x = 1,
    -- method definitions, etc
    export = function(self) return { x = self.x } end,
}
function MyClass:method()
    -- ... your code ...
end
return MyClass
```

## New and init

Instances can be created with `:new()` (or `:new { ... }`:

```lua
local o1 = MyClass:new()
local o2 = MyClass:new { x = 2 }
```

Normally, all arguments to `:new` will override the defaults / static
fields. That is, unless an `:init` method is defined - it will be
called during class initialization with any arguments that `:new`
received:

```lua
local Cat = class {}
function Cat:init(args)
    self.sound = args.sound or "meow"
end
```

## Inheritance

Inheritance is possible with the `:inherit` class-method:

```lua
local Animal = class { sound = "" }
function Animal:say() return self.sound end
local Cate = Animal:inherit { sound = "mow" }
local Doge = Animal:inherit { sound = "wow" }

print(Cate:new():say()) -- will say "mow"
print(Doge:new():say()) -- will say "wow"
```

## Class objects

Instances can access the class object using the `.cls` field.

Arguments passed to the class definition serve the roles of both
"static" fields, and default values for instances. Instances can
safely modify them, and the original will still be accessible via the
`.cls` field:

```lua
local Animal = class { sound = "" }
local my_cate = Animal:new()
my_cate.sound = "moew"
assert(Animal.sound == "")
assert(my_cate.cls.sound == "")
```

Functions that take arbitrary class instances can use this mechanism,
e.g. to create shallow copies:

```lua
function shallow_copy(o)
    local cls = o.cls
    return cls:new(o)
end
```
