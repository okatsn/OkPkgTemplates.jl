```@meta
CurrentModule = OkPkgTemplates
```

## Macro: create *expression* to be executed in its surrounded scope

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


## Reference

[Emma Boudreau - Metaprogramming in Julia: A Full Overview](https://towardsdatascience.com/metaprogramming-in-julia-a-full-overview-2b4e811f1f77)

## Tips

!!! tip "Tips"
    - Multiline `quote ... end` is in fact `Expr(:block, ex1, ex2, ...)`
    - `esc` escape `ex::Expr` from macro expansion; it is used to "violate" macro hygiene when necessary. See [Metaprogramming/#Hygiene](https://docs.julialang.org/en/v1/manual/metaprogramming/#Hygiene).
    - `macroexpand` and `@macroexpand` is very useful in debugging. See [metaprogramming/#Hold-up:-why-macros?](https://docs.julialang.org/en/v1/manual/metaprogramming/#Hold-up:-why-macros?)

## Use `macro` or `@eval`uate an *expression*

### It is generally safe to use macro defined in a clean `module`.

```@example cx7d
module HelloWorld
    f = sin

    macro definex(x)
        return quote
            HelloWorld.x = $x
            HelloWorld.sinx = f($x)
        end
    end

    HelloWorld.x = 5.99
    HelloWorld.sinx = f(x)
end
```

```@example cx7d
HelloWorld.x
```

```@example cx7d
HelloWorld.sinx
```

```@example cx7d
x = 5
f = cos
f(x)
```


```@example cx7d
HelloWorld.@definex 0
HelloWorld.x
```

```@example cx7d
HelloWorld.sinx
```

```@example cx7d
x
```

!!! tip
    Expression returned by `macro` is executed under the scope that the `macro` is defined.
    - Noted that in `@definex` use `f` defined in `module HelloWorld ... end`

### The same result/utility can be achieved with `function` using `@eval`:

```@example as5w
module HelloWorld
    f = sin

    function definex(x)
        ex = quote
            HelloWorld.x = $x
            HelloWorld.sinx = f($x)
        end
        @eval $ex
    end

    HelloWorld.x = 5.99
    HelloWorld.sinx = f(x)
end
HelloWorld.sinx
```

```@example as5w
HelloWorld.definex(0)
x = 5
HelloWorld.x
```

```@example as5w
HelloWorld.sinx
```


### Be ware of the difference between `@eval ex` and `@eval $ex`

```@example afd8s
f = sin
x = 0
ex = quote
    x = $x
    sinx = f($x)
end
```



```@repl afd8s
@eval ex
@macroexpand @eval ex
sinx
```

The `ERROR: UndefVarError: 'sinx' not defined` occurred since `ex` is passed to `@eval` as `Symbol`; thus, nothing executed. 
Noted that `ERROR: UndefVarError: 'ex' not defined` won't be raised when `ex` is not defined!


```@repl afd8s
@eval $ex
@macroexpand @eval $ex
sinx
```


## Example 

### Say Hello
#### the say-hello function
```@docs
OkPkgTemplates.sayhello3
```

#### The say-hello macro built upon
```@docs
OkPkgTemplates.@sayhello3
```

### Knowing Where am I

```@repl
using OkPkgTemplates

OkPkgTemplates.DEFAULT_DESTINATION

OkPkgTemplates.@chkdest

OkPkgTemplates.DEFAULT_DESTINATION
```
