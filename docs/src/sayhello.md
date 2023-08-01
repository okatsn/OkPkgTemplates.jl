```@meta
CurrentModule = OkPkgTemplates
```

The use of `macro` is confusing. Thus, I made an exemplary `@sayhello3` to help me understand.

[`macro` returns *expression*](https://docs.julialang.org/en/v1/manual/metaprogramming/#man-macros), and the `ex::Expr` is executed in the scope just like `@eval(mod::Module, ex)` (`mod` can be `Main`).

`ex::Expr` uses the surrounded scope (lexical scope):

```@example a789
macro f45()
    x = 5
    return :(f(45))
end
```

```@example a789
f = sin
@f45
```

```@example a789
f = tan
@f45
```

Variable defined in expression won't contaminate the surrounded scope,
```@repl a789
@f45

x
```

unless

```@example b789
module Hello
    macro f45brutal()
        Hello.x = 5
        return :(f(45))
    end
    Hello.x = 4.99
end
```

```@repl b789

Hello.x

Hello.@f45brutal

Hello.x
```

Error occurred in `Hello.@f45brutal` because `Hello.f` is not defined. Noted that this is true for `Main` scope; yuo can redefine variables/functions under the `Main` scope this way.

!!! tip "Tips"
    - Multiline `quote ... end` is in fact `Expr(:block, ex1, ex2, ...)`


## The say-hello function
```@docs
OkPkgTemplates.sayhello3
```

## The say-hello macro built upon
```@docs
OkPkgTemplates.@sayhello3
```

## The `whereami` example

### Macro call
```@docs
OkPkgTemplates.@whereami
```

```@repl
using OkPkgTemplates

OkPkgTemplates.DEFAULT_DESTINATION()

OkPkgTemplates.@whereami

OkPkgTemplates.DEFAULT_DESTINATION()
```

### Function call
```@docs
OkPkgTemplates.whereami
```

```@example a123
using OkPkgTemplates
OkPkgTemplates.DEFAULT_DESTINATION() = "" #hide
OkPkgTemplates.DEFAULT_DESTINATION()
```

```@example a123
OkPkgTemplates.whereami()
```

```@example a123
OkPkgTemplates.DEFAULT_DESTINATION()
```

