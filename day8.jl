include("adventofcodehttp.jl")
input = day(8)

acc(arg) = function (position, accumulator) 
    position + 1 => accumulator + arg
end

nop(arg) = function (position, accumulator)
    position + 1 => accumulator
end

jmp(arg) = function (position, accumulator)
    position + arg => accumulator
end

functions = Dict(
    "acc" => acc,
    "nop" => nop,
    "jmp" => jmp
)

instructions = map(split(input, "\n")) do line
    func, arg = split(line, " ")
    functions[func](parse(Int, arg))
end


function handhalt(instructions) 
    accumulator = 0
    position = 1
    visitedpos = Set()
    while true 
        if position in visitedpos
            return position, accumulator
        else
            push!(visitedpos, position)
        end
        position, accumulator = instructions[position](position, accumulator)
    end
end

function parseinstruction(instructions::Array{Pair{Function,Int64}}, position::Int64=1, accumulator::Int64=0, visitedpositions::Set{Int64}=Set()) 
    if position in visitedpositions || position > length(instructions)
        return position, accumulator
    else
        push!(visitedpositions, position)
    end
    instruction, argument = instructions[position]
    position, accumulator = instruction(argument)(position, accumulator)
    return parseinstruction(instructions, position, accumulator, visitedpositions)
end

using Test
testinput = """nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6"""

testinstructions = map(split(testinput, "\n")) do line
    func, arg = split(line, " ")
    functions[func](parse(Int, arg))
end

@test handhalt(testinstructions)[2] == 5

handhalt(instructions)

# Part 2

instructions2 = map(split(input, "\n")) do line
    func, arg = split(line, " ")
    functions[func] => parse(Int, arg)
end


testinstructions2 = map(split(testinput, "\n")) do line
    func, arg = split(line, " ")
    functions[func] => parse(Int, arg)
end


function handhalt2(instructions) 
    accumulator = 0
    position = 1
    visitedpos = Set()
    functionswappos = Set()
    checkswap = true
    while true 
        if position in visitedpos 
            checkswap = true
            position = 1
            accumulator = 0
            visitedpos = Set()
        else
            push!(visitedpos, position)
        end
        if position > length(instructions)
            return position, accumulator
        end
        func, arg = instructions[position]
        if checkswap && !(position in functionswappos)
            if func == nop
                checkswap = false
                func = jmp
                push!(functionswappos, position)
            elseif func == jmp
                checkswap = false
                func = nop
                push!(functionswappos, position)
            end
        end
        position, accumulator = func(arg)(position, accumulator)
    end
end

@test handhalt2(testinstructions2)[2] == 8

handhalt2(instructions2)


M = [i for i in instructions2, x in 1:(length(instructions2)[1])]
for i in 1:(length(instructions2)[1]) 
    x, y = M[i,i]
    if x == nop
        M[i,i] = jmp => y
    elseif x == jmp
        M[i,i] = nop => y
    end
end

function handhalt3(instructions) 
    accumulator = 0
    position = 1
    visitedpos = Set()
    while true 
        if position in visitedpos 
            return position, nothing
        else
            push!(visitedpos, position)
        end
        if position > length(instructions)[1]
            return position, accumulator
        end
        position, accumulator = instructions[position](position, accumulator)
    end
end

M = map(x -> x.first(x.second), M)

A = map(1:size(M)[1]) do e
    M[:, e]
end

G = asyncmap(handhalt3, A)

RY = filter(x -> x != nothing, G)


parseinstruction(instructions2)
typeof(instructions2)