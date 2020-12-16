include("adventofcodehttp.jl")
input = day(15)

function part1(input, l) 
    values = map(x -> parse(Int, x), split(strip(input), ","))
    for i in length(values):l
        value = values[i]
        lastoccurance = findlast(x -> x == value, values[1:i-1])
        if isnothing(lastoccurance)
            append!(values, 0)
        else
            append!(values, i - lastoccurance)
        end
    end
    values
end

function part2(input, l) 
    values = map(x -> parse(Int, x), split(strip(input), ","))
    lo = Dict(map(x -> x[2] => (x[1], x[1]), enumerate(values)))
    lastvalue = values[end]
    for i in (length(values)+1):l
        a, b = get(lo, lastvalue, (i,i))
        diff = b - a
        c, d = get(lo, diff, (i,i))
        lo[diff] = (d, i)
        lastvalue = diff
    end
    lastvalue
end

part2(input, 30000000)
