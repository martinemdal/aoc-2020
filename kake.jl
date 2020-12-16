v = [1,2,3]
i = findfirst(x -> x == 2020, [x + y + z for x in v, y in v, z in v])
v[i[1]] * v[i[2]] * v[i[3]]