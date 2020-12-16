include("adventofcodehttp.jl")
input = day(3)

lines = split(input, "\n")
matrix = map(x -> split(x, ""), lines)
function rd(r, d) 
    i = 1
    j = 1
    w = size(matrix[1])[1]
    h = size(matrix)[1]
    c = 0
    while i <= h 
        if matrix[i][j] == "#" 
            c += 1
        end
        j = (j + r) % w
        i = i + d
        if j == 0 
            j = w
        end
    end
    c
end

reduce(*, [ rd(1, 1) 
rd(3, 1)
rd(5, 1)
rd(7, 1)
rd(1, 2) ])