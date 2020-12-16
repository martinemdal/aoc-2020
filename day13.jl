using Primes
include("adventofcodehttp.jl")
input = day(13)
# input = """939
# 7,13,x,x,59,x,31,19"""
function part1(input) 
    timestampstring, buses = split(input, "\n")
    timestamp = parse(Int, timestampstring)
    buslist = split(buses, ",")
    busnumberstrings = filter(x -> x != "x", buslist)
    busnumbers = map(x -> parse(Int, x), busnumberstrings)
    departtime = copy(timestamp)
    while !any(bustime -> departtime % bustime == 0, busnumbers)
        departtime = departtime + 1
    end
    busnumber = busnumbers[findfirst(x -> departtime % x == 0, busnumbers)]
    waittime = departtime - timestamp
    busnumber * waittime
end

# part1(input)

function nextalign(buses) 
    buses = reduce(hcat, buses)
    maxbusnumber = maximum(buses[2,:])
    i = findfirst(x -> x == maxbusnumber, buses)
    maxbusnumbertimestampoffset = buses[1, i[2]]
    start = -copy(maxbusnumbertimestampoffset)

    busfu = mapslices(buses, dims=1) do sl
        x -> (x + sl[1]) % sl[2] == 0
    end
    start = maxbusnumber - maxbusnumbertimestampoffset
    while !all(x -> x(start), busfu)
        start += maxbusnumber
    end
    start
end

function part2(input) 
    timestampstring, buses = split(input, "\n")
    timestamp = parse(Int, timestampstring)
    buslist = split(buses, ",")
    buses = map(enumerate(buslist)) do (i, busnumber)
        if busnumber == "x"
            nothing
        else
            (n::Int64) -> (n + i - 1) % parse(Int, busnumber) == 0
            [i - 1, parse(Int, busnumber)]
        end
    end
    buses = buses[buses.!==nothing]
    # nextalign(buses)
end 

using Test
function joinsteps(steps, stepsize) 
    sortedsteps = sort(steps)
    step, offset = sortedsteps[end]
    start = stepsize
    while !all(x -> (start + x[2]) % x[1] == 0, sortedsteps[1:end])
        start += stepsize
    end
    start
end
function joinsteps(steps) 
    sortedsteps = sort(steps)
    step, offset = sortedsteps[end]
    start = step - offset
    while !all(x -> (start + x[2]) % x[1] == 0, sortedsteps[1:end-1])
        start += step
    end
    start
end
function joinsteps2(steps) 
    sortedsteps = sort(steps)
    step, offset = sortedsteps[end]
    # start = step - offset
    start = reduce(*, map(x -> x[1], steps))
    while !all(x -> (start + x[2]) % x[1] == 0, sortedsteps[1:end])
        start += step
    end
    start
end
function joinstep(step1, step2)
    offset1, ID1 = step1
    offset2, ID2 = step2
    start = ID1 - offset1
    while (start + offset2) % ID2 != 0
        start += ID1
    end
    [0, start]
end
function grj(step1, step2)
    ID1, offset1 = step1
    ID2, offset2 = step2
    start = ID1 - offset1
    while (start + offset2) % ID2 != 0
        start += ID1
    end
    first = copy(start)
    start += ID1
    while (start + offset2) % ID2 != 0
        start += ID1
    end
    second = copy(start)
    step = second - first
    offset = step - first
    [step, offset]
end

busset = map(x -> [x[2],x[1]],part2(input))
step1, step2 = busset[1], busset[2]
busset

g = reduce(grj, busset)
g[1] - g[2]