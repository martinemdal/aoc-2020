input = read("input.txt", String)

x = map(l -> begin 
    if l == "V"
        [-1,0]
    elseif l == "H"
        [1,0]
    elseif l == "O"
        [0,1]
    else
        [0,-1]
    end
end
, split(input, ""))
for i in 2:(length(x)) 
    x[i] = x[i-1] + x[i]
end

println(x)