"""
`stringscore(str)` gives an absolute score for a string; the order of score from large to small corresponds to the alphabetical order.
For a string less than 100 characters, the score should not exceeds one.

# Example
```julia-repl
julia> stringscore.(["AAA", "Aa", "BCD"])
3-element Vector{Float64}:
 0.0656565
 0.06597
 0.06667680000000001
```
"""
function stringscore(str)
    ordnum = collect(str) .|> Int # ordnum of 'A' is small, 'B' is large; capitalized ones are small.
    lens = length(ordnum)
    strscore = ordnum .* 0.1
    weighted_score = [score * 0.01^i for (i,score) in enumerate(strscore)]
    # for later digits, it should be much smaller
    final_score = sum(weighted_score)
end
