include("adventofcodehttp.jl")
input = strip(day(11))
# input = """L.LL.LL.LL
# LLLLLLL.LL
# L.L.L..L..
# LLLL.LL.LL
# L.LL.LL.LL
# L.LLLLL.LL
# ..L.L.....
# LLLLLLLLLL
# L.LLLLLL.L
# L.LLLLL.LL"""

safeget(A, m, n) = get(A, CartesianIndex(m, n), 0)
neighbors(seatmatrix, i) = [
    safeget(seatmatrix, i[1] - 1, i[2] - 1)
    safeget(seatmatrix, i[1] - 1, i[2])
    safeget(seatmatrix, i[1] - 1, i[2] + 1)
    safeget(seatmatrix, i[1], i[2] + 1)
    safeget(seatmatrix, i[1], i[2] - 1)
    safeget(seatmatrix, i[1] + 1, i[2] - 1)
    safeget(seatmatrix, i[1] + 1, i[2])
    safeget(seatmatrix, i[1] + 1, i[2] + 1)
]

function lookatseat(seatmatrix, i, direction) 
    nextseatlocation = (i[1] + direction[1], i[2] + direction[2])
    nextseat = get(seatmatrix, nextseatlocation, -1)
    if nextseat == -1
        0
    elseif nextseat == 1
        1
    elseif nextseat == 2
        2
    else
        lookatseat(seatmatrix, nextseatlocation, direction)
    end
end
guccigang()

neighbors2(seatmatrix, i) = [
    lookatseat(seatmatrix, i, [-1,-1])
    lookatseat(seatmatrix, i, [-1,0])
    lookatseat(seatmatrix, i, [-1,1])
    lookatseat(seatmatrix, i, [0,-1])
    lookatseat(seatmatrix, i, [0,1])
    lookatseat(seatmatrix, i, [1,-1])
    lookatseat(seatmatrix, i, [1,0])
    lookatseat(seatmatrix, i, [1,1])
]

guccigang() = println(neighbors2([
    1 1 1
    0 1 1
    2 2 2
], (1,1)))

function predictseats2(seatmatrix) 
    map(CartesianIndices(seatmatrix)) do i
        seat = seatmatrix[i]
        n = neighbors2(seatmatrix, i)
        if seat == 1 && !(2 in n)
            2
        elseif seat == 2 && count(x -> x == 2, n) >= 5
            1
        else
            seat
        end
    end
end

function predictseats(seatmatrix) 
    asyncmap(CartesianIndices(seatmatrix)) do i
        seat = seatmatrix[i]
        n = neighbors(seatmatrix, i)
        if seat == 1 && !(2 in n)
            2
        elseif seat == 2 && count(x -> x == 2, n) >= 4
            1
        else
            seat
        end
    end
end

function getmatrix(input) 
    inputlines = split(input, "\n")
    height = length(inputlines[1])
    width = length(inputlines)
    inputoneline = replace(input, r"\n" => "")
    splitinputstring = split(inputoneline, "")
    seatletters = reshape(splitinputstring, height, width)
    seatmatrix = map(seatletters) do seat
        if seat == "."
            0
        elseif seat == "L"
            1
        elseif seat == "#"
            2
        end
    end
    seatmatrix
end
function assigment1(input) 
    seatmatrix = getmatrix(input)
    newseatmatrix = predictseats(seatmatrix)
    while seatmatrix != newseatmatrix
        seatmatrix = newseatmatrix
        newseatmatrix = predictseats(seatmatrix)
    end
    newseatmatrix
end

function assigment2(input) 
    seatmatrix = getmatrix(input)
    newseatmatrix = predictseats2(seatmatrix)
    while seatmatrix != newseatmatrix
        seatmatrix = newseatmatrix
        newseatmatrix = predictseats2(seatmatrix)
        println(count(x -> x == 2, newseatmatrix))
    end
    newseatmatrix
end

count(x -> x == 2, assigment2(input))
