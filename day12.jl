include("adventofcodehttp.jl")

@time input = day(12)
import Pkg
Pkg.add("BenchMarkTools")

function south!(position, facing, value) 
    position[1] = position[1] - value
end
function north!(position, facing, value) 
    position[1] = position[1] + value
end
function east!(position, facing, value) 
    position[2] = position[2] + value
end
function west!(position, facing, value) 
    position[2] = position[2] - value
end
function left!(position, facing, value) 
    n = value ÷ 90
    for i in 1:n 
        if facing == [1,0]
            facing[1] = 0
            facing[2] = -1
        elseif facing == [0,-1]
            facing[1] = -1
            facing[2] = 0
        elseif facing == [-1,0]
            facing[1] = 0
            facing[2] = 1
        elseif facing == [0,1]
            facing[1] = 1
            facing[2] = 0
        end
    end
end
function right!(position, facing, value) 
    n = value ÷ 90
    for i in 1:n 
        if facing == [1,0]
            facing[1] = 0
            facing[2] = 1
        elseif facing == [0,1]
            facing[1] = -1
            facing[2] = 0
        elseif facing == [-1,0]
            facing[1] = 0
            facing[2] = -1
        elseif facing == [0,-1]
            facing[1] = 1
            facing[2] = 0
        end
    end
end
function forward!(position, facing, value) 
    if facing[1] == 1
        position[1] = position[1] + value
    elseif facing[1] == -1
        position[1] = position[1] - value
    elseif facing[2] == 1
        position[2] = position[2] + value
    elseif facing[2] == -1
        position[2] = position[2] - value
    end
end

function assignment1(input)

    instructions = Dict(
        'S' => south!,
        'N' => north!,
        'E' => east!,
        'W' => west!,
        'L' => left!,
        'F' => forward!,
        'R' => right!
    )

    input = strip(input)
    splitinput = split(input, "\n")
    directives = map(x -> (instructions[x[1]], parse(Int, x[2:end])), splitinput)

    position = [0,0]
    facing = [0,1]

    for directive in directives
        directive[1](position, facing, directive[2])
    end
    position 
end

function south2!(position, waypoint, value) 
    waypoint[1] = waypoint[1] - value
end
function north2!(position, waypoint, value) 
    waypoint[1] = waypoint[1] + value
end
function east2!(position, waypoint, value) 
    waypoint[2] = waypoint[2] + value
end
function west2!(position, waypoint, value) 
    waypoint[2] = waypoint[2] - value
end

function left2!(position, waypoint, value) 
    rotasjon = [
        0 1 
        -1 0 
    ]
    n = value ÷ 90
    ns, ew = rotasjon^n * waypoint
    waypoint[1] = ns
    waypoint[2] = ew
end
function right2!(position, waypoint, value) 
    rotasjon = [
        0 -1 
        1 0 
    ]
    n = value ÷ 90
    ns, ew = rotasjon^n * waypoint
    waypoint[1] = ns
    waypoint[2] = ew
end
function forward2!(position, waypoint, value) 
    ns, ew = waypoint * value
    position[1] = position[1] + ns
    position[2] = position[2] + ew
end

function assignment2(input)

    instructions = Dict(
        'S' => south2!,
        'N' => north2!,
        'E' => east2!,
        'W' => west2!,
        'L' => left2!,
        'F' => forward2!,
        'R' => right2!
    )

    input = strip(input)
    splitinput = split(input, "\n")
    directives = map(x -> (instructions[x[1]], parse(Int, x[2:end])), splitinput)

    waypoint = [1,10]
    position = [0,0]

    for directive in directives
        directive[1](position, waypoint, directive[2])
    end
    sum(map(abs, position))
end

@time assignment2(input)