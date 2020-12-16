include("adventofcodehttp.jl")
input = day(9)

function finderror(preamble, numbers) 
    N = map(x -> parse(Int, x), split(numbers, "\n"))
    R = Dict(map(preamble:(size(N)[1])) do i
        n = N[(i-preamble+1):i]
        i => union([a == b ? nothing : n[a] + n[b] for a in 1:(size(n)[1]), b in 1:(size(n)[1])])
    end)
    U = map(x -> !(N[x] in R[x-1]), (preamble+1):(size(N)[1]))
    N[findfirst(U) + preamble]
end

finderror(25, input)

function findrange(number, A) 
    l = size(A)[1]
    𝝎 = [(n+m-1) > l ? 0 : sum(A[n:(n+m-1)]) for m in 1:l, n in 1:l]
    index = findfirst(a -> a == number, 𝝎)
    𝝎
    start = index[2]
    endd = index[2] + index[1] - 1
    sorted = sort(A[start:endd])
    minimum(sorted) + maximum(sorted)
end

slarg = """35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576"""

ralg = map(x -> parse(Int, x), split(input, "\n"))
findrange(144381670, ralg)