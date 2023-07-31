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

# Example 1:

```jldoctest bw1
name = "Bruce Willey"

# output
"Bruce Willey"
```

```jldoctest bw1
julia> @sayhello3 \$name
ERROR: UndefVarError: `name` not defined
```

# Example 2:
```jldoctest
@sayhello3 name = "Bruce Willey"

# output
"Hello world! Bruce Willey"
```

# Example 3
Noted that in the following call of `@sayhello3`, `@sayhello3(str::String)` is dispatched.

```jldoctest bw1
@eval @sayhello3 \$name

# output
"Hello world! Bruce Willey"
```


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

# Example
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
