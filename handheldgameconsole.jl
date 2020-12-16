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

function getinstructionsfromstring(string::String) 
    map(split(string, "\n")) do line
        func, arg = split(line, " ")
        functions[func] => parse(Int, arg)
    end
end

function getinstructions(file="input.txt") 
    map(split(read(file, String), "\n")) do line
        func, arg = split(line, " ")
        (functions[func], parse(Int, arg))
    end
end


instructions = getinstructions()
M = [x for x in instructions, y in instructions]
for i in 1:size(M)[1] 
    instruction, argument = M[i,i]
    M[i,i] = if instruction == jmp
        (nop, argument)
    elseif instruction == nop 
        (jmp, argument)
    else
        (instruction, argument)
    end
end
M