using Test
include("adventofcodehttp.jl")
@time begin
    input = day(4)

    function valid(line) 
        fields = split(line, " ")
        s = Set()
        for field in fields
            keyvalue = split(field, ":")
            if size(keyvalue)[1] == 2
                key, value = keyvalue
                push!(s, key)
            end
        end
        "byr" ∈ s &&
        "iyr" ∈ s &&  
        "eyr" ∈ s &&
        "hgt" ∈ s &&
        "hcl" ∈ s &&
        "ecl" ∈ s &&
        "pid" ∈ s
    end

    pi(s) = parse(Int, s)

    function valid2(line) 
        fields = split(line, " ")
        s = Dict()
        for field in fields
            keyvalue = split(field, ":")
            if size(keyvalue)[1] == 2
                key, value = keyvalue
                push!(s, key => value)
            end
        end
        pi(get(s, "byr", "0")) in 1920:2002 &&
    pi(get(s, "iyr", "0")) in 2010:2020 &&
    hgt(get(s, "hgt", "0cm")) &&
    hcl(get(s, "hcl", "0cm")) &&
    ecl(get(s, "ecl", "")) &&
    pid(get(s, "pid", "")) &&
    pi(get(s, "eyr", "0")) in 2020:2030 &&
    true
    end

    function hcl(i) 
        occursin(r"#[a-f0-9]{6}", i)
    end

    function hgt(i) 
        a = [] 
        if length(i) < 3
            return false
        elseif i[end - 1:end] == "cm" 
            a = 150:193
        elseif i[end - 1:end] == "in" 
            a = 59:76
        else
            return false
        end
        pi(i[1:end - 2]) in a
    end

    function ecl(i) 
        i in ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"]
    end

    function g(lines) 
        map(valid2, lines)
    end

    function pid(i) 
        occursin(r"^[0-9]{9}$", i)
    end


    count(g(map(r -> replace(r, "\n" => " "), split(input, "\n\n"))))


end