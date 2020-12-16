include("adventofcodehttp.jl")
input = day(14)

function maskfunction(mask) 
    or, and = mapslices(e -> parse(UInt64, join(e), base=2), 
        mapreduce(c -> c == 'X' ? [0 1] : c == '1' ? [1 1] : [0 0], vcat, collect(mask)),
    dims=1)
    x -> or | x & and
end

function p1(input) 
    lines = split(strip(input), "mask = ")[2:end][2]
    sl = split(lines, "\n")
    mf = maskfunction(sl[1])
    map(x -> mf(parse(UInt64, split(x, " = ")[2])), sl[2:end-1])
end

function toint(s) 
    Int64(parse(UInt64, s, base=2))
end

function applymask(bitstring, mask) 
    join(map(enumerate(bitstring)) do (i,l)
        mask[i] == 'X' ? l : mask[i]
    end)
end

function applymask2(bitstring, mask) 
    join(map(enumerate(bitstring)) do (i,l)
        mask[i] == 'X' ? 'X' : mask[i] == '1' ? 1 : l
    end)
end

function maskarray(mask) 
    array = [[]]
    map(enumerate(mask)) do (i, m) 
        if m == '0' || m == '1'
            for a in array 
                append!(a, m)
            end
        elseif m == 'X'
            for a in array 
                append!(a, '1')
            end
            newarray = deepcopy(array)
            for a in newarray 
                a[end] = '0'
            end
            array = vcat(array, newarray)
        end
    end
    map(join, array)
end

function part1(input) 
    lines = split(strip(input), "\n")
    lines2 = map(line -> split(line, " = "), lines)
    xprefix = 64 - 36
    prefix = join(map(x -> "X", 1:xprefix))
    instructions = map(lines2) do line
        (operation=line[1] ,mask=if line[1] == "mask"
            prefix * line[2]
        elseif startswith(line[1], "mem")
            Base.bitstring(UInt64(parse(UInt64, line[2])))
        end)
    end
    mask = ""
    d = Dict()
    for instruction in instructions
        if instruction.operation == "mask"
           global mask = instruction.mask
        else
            valueaftermask = applymask(instruction.mask, mask)
            v = parse(UInt64, valueaftermask, base=2)
            push!(d, instruction.operation=>v)
        end
    end
    Int64(sum(values(d)))
end

function part2(input) 
    lines = split(strip(input), "\n")
    lines2 = map(line -> split(line, " = "), lines)
    xprefix = 64 - 36
    prefix = join(map(x -> "0", 1:xprefix))
    instructions = map(lines2) do line
        (operation=line[1] ,mask=if line[1] == "mask"
            prefix * line[2]
        elseif startswith(line[1], "mem")
            Base.bitstring(UInt64(parse(UInt64, line[2])))
        end)
    end
    mask = ""
    d = Dict()
    w = ""
    for instruction in instructions
        if instruction.operation == "mask"
           mask = instruction.mask
        else
            ad = Base.bitstring(parse(UInt64, replace(instruction.operation, "mem["=>"")[1:end-1]))
            www = map(x -> applymask2(ad, x), maskarray(mask))
            wwww = maskarray(applymask2(ad, mask))
            valueaftermask = applymask2(instruction.mask, mask)
            for ww in wwww
                push!(d, ww => instruction.mask)
            end
        end
    end
    Dict(map(collect(d)) do p
        toint(p.first) => toint(p.second)
    end)
end

println(sum(values(part2(input))))

