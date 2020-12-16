using HTTP
using Test

@time begin 
include("adventofcodehttp.jl")
input = day(2)

inputlines = split(input, "\n")[1:end-1]

function valid(password) 
    a,b,c = split(password, " ")
    d1p, d2p = split(a, "-")
    d1 = parse(Int, d1p)
    d2 = parse(Int, d2p)
    L = length(filter(w -> w == b[1], c))
    if L >= d1 && L <= d2 
        return true
    end
    return false
end
function valid2(password) 
    a,b,c = split(password, " ")
    d1p, d2p = split(a, "-")
    d1 = parse(Int, d1p)
    d2 = parse(Int, d2p)
    l = b[1]
    if c[d1] == l && c[d2] != l
        true
    elseif c[d2] == l && c[d1] != l
        true
    else
        false
    end
end
count(map(valid2, inputlines))
end

@test valid("1-3 b: cdefg") == false
@test valid("1-3 a: abcde") == true
@test valid("2-9 c: ccccccccc") == true

@test valid2("1-3 a: abcde") == true
@test valid2("1-3 b: cdefg") == false
@test valid2("2-9 c: ccccccccc") == false