r = (d -> (Dict("sukker" => 2, "mel" => 3, "melk" => 3, "egg" => 1), d))(reduce((dict1, dict2) -> Dict(map(key -> key => get(dict1, key, 0) + get(dict2, key, 0), collect(union(keys(dict1), keys(dict2))))), map(x -> Dict(map(y -> (x -> x[1] => parse(Int, x[2]))(split(y, ": ")), split(x, ", "))), split(read("input.txt", String), "\n"))))
(x -> x[1])(r)