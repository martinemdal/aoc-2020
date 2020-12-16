include("adventofcodehttp.jl")
input = day(1)

function part1(input) 
    lines = split(strip(input), "\n")
    numbers = map(line -> parse(Int, line), lines)
    allnumbersadded = [i + j for i in numbers, j in numbers]
    for i in 1:length(numbers) 
        allnumbersadded[i, i] = 0
    end
    index = findfirst(x -> x == 2020, allnumbersadded)
    number1 = numbers[index[1]]
    number2 = numbers[index[2]]
    return number1 * number2
end

part1(input)
