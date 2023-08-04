"""
```
macro whereami()
    path_parse_time = "Hello/World" # parse time
    println("Destination defined at the parse time: \$(path_parse_time)")
    return quote
        path_runtime = chkdest()
        println("Destination defined at the runtime: \$(path_runtime)")
        OkPkgTemplates.DEFAULT_DESTINATION = \$path_parse_time
    end
end
```
"""
macro whereami()
    path_parse_time = "Hello/World" # parse time
    println("Destination defined at the parse time: $(path_parse_time)")
    return quote
        path_runtime = chkdest()
        println("Destination defined at the runtime: $(path_runtime)")
        OkPkgTemplates.DEFAULT_DESTINATION = $path_parse_time
    end
end

"""
```
function whereami()
    # OkPkgTemplates.DEFAULT_DESTINATION = dest
    # # This is not allowed at the compile time
    path_parse_time = chkdest()

    ex = quote
        OkPkgTemplates.DEFAULT_DESTINATION = \$path_parse_time
    end
    @eval(OkPkgTemplates, \$ex)
    return path_parse_time
end
```
"""
function whereami()
    # OkPkgTemplates.DEFAULT_DESTINATION = dest
    # # This is not allowed at the compile time
    path_parse_time = chkdest()

    ex = quote
        OkPkgTemplates.DEFAULT_DESTINATION = $path_parse_time
    end
    @eval(OkPkgTemplates, $ex)
    return path_parse_time
end
