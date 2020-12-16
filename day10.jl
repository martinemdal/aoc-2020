include("adventofcodehttp.jl")
input = day(10)
# input = """16
# 10
# 15
# 5
# 1
# 11
# 7
# 19
# 6
# 12
# 4"""
n = Set(map(x -> parse(Int, x), split(input, "\n")))
n = n ∪ (maximum(n) + 3)
r = sort(collect(n))
splits = vcat(1, filter(2:length(r)) do i
    r[i] - r[i - 1] == 3
end)
println(r)
safesubgraphs = map(2:length(splits)) do i
    r[splits[i - 1]:(splits[i] - 1)]
end
safesubgraphs = vcat(safesubgraphs, [[maximum(n)]])

function djc!(foundpaths, path, adapters) 
    c = filter(adapter -> (adapter <= path[end] + 3) && (adapter > path[end]), adapters)
    if isempty(c) 
        if isempty(adapters) 
            push!(foundpaths, path)
        end
        return
    end
    map(adapter -> djc!(foundpaths, vcat(path, adapter), symdiff(adapters, adapter)), collect(c))
end

function findvalidpaths!(foundpaths, path, adapters) 
    validadapters = filter(adapter -> (adapter <= path[end] + 3) && (adapter > path[end]), adapters)
    max = maximum(path ∪ adapters)
    if max ∈ path
        push!(foundpaths, path)
    end
    if isempty(validadapters) 
        if isempty(adapters) 
            push!(foundpaths, path)
        end
        return
    end
    map(adapter -> findvalidpaths!(foundpaths, vcat(path, adapter), symdiff(adapters, adapter)), collect(validadapters))
end

function stitchpaths(safesubgraphs) 
    foundpaths = [[0]]
    for subgraph in safesubgraphs
        djc!(foundpaths, foundpaths[end], Set(subgraph))
        foundpaths = [foundpaths[end]]
    end
    foundpaths
end
reduce(*, map(safesubgraphs) do subgraph
    fp = []
    findvalidpaths!(fp, subgraph[1], Set(subgraph))
    length(fp)
end)
safesubgraphs[1] = [0,1,2,3,4]

mergewithplus(d1,d2) = mergewith(+, d1, d2)
map(stitchpaths(safesubgraphs)) do path
    d = reduce(mergewithplus,
        map(2:length(path)) do i
        Dict(path[i] - path[i - 1] => 1)
    end)
    d[3] * d[1]
end
