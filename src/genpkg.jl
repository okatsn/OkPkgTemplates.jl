"""
`sayhello3(name) = "Hello world! \$name"`, an example to understand metaprogramming.
"""
function sayhello3(name)
    "Hello world! $name"
end

sayhello3() = sayhello3("")

"""
```
macro sayhello3(str::String)
    return Expr(:block, :(sayhello3(\$str)))
end
```

# Example
```jldoctest
@sayhello3 "Bruce Willey"

# output
"Hello world! Bruce Willey"
```
"""
macro sayhello3(str::String)
    ex = Expr(:block, :(sayhello3($str)))
    return ex
end

"""
```
macro sayhello3(ex::Expr)
    return Expr(:block, :(sayhello3(\$(last(ex.args)))))
end
```

# Example: variable `name` is not defined in macro's scope

```jldoctest bw1
name = "Bruce Willey"

# output
"Bruce Willey"
```

```jldoctest bw1
julia> @sayhello3 \$name
ERROR: UndefVarError: `name` not defined
```

!!! tip "Explain"
    - `name` is passed as expression in this case, and it is not defined since macro dispatch is not based on the AST evaluated at runtime. Thus an error of `UndefVarError` is raised.
    - See [Macros and dispatch](https://docs.julialang.org/en/v1/manual/metaprogramming/#Macros-and-dispatch) for more information.


# Example: a creative application
```jldoctest
@sayhello3 name = "Bruce Willey"

# output
"Hello world! Bruce Willey"
```

!!! tip "Explain"
    In this example, the last argument of the expression `name = "Bruce Willey"` is "Bruce Willey".




# Example 3: Use `@eval` if you want `name` be evaluated

```jldoctest bw1
@eval @sayhello3 \$name

# output
"Hello world! Bruce Willey"
```
!!! tip "Explain"
    - `@eval` evalute the expression `@sayhello3 \$name` at runtime.
    - Thus, the argument for `@sayhello3` is evaluated as `String`, and `@sayhello3(str::String)` is the dispatched method.


"""
macro sayhello3(ex::Expr)
    return Expr(:block, :(sayhello3($(last(ex.args)))))
end

"""
```
macro sayhello3(symb::Symbol)
    return Expr(:block, :(sayhello3(\$(string(symb)))))
end
```

# Example: A single the runtime variable is rendered as `Symbol`
```jldoctest
name = "Bruce Willey"
@sayhello3 name

# output
"Hello world! name"
```
"""
macro sayhello3(symb::Symbol)
    return Expr(:block, :(sayhello3($(string(symb)))))
end
