input = read("numbers.txt", String)
is = sort(map(x -> parse(Int, x), split(input, ",")))
for i in 1:size(is)[1]
    if is[i] != i 
        println(i)
        break
    end
end