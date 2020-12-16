include("adventofcodehttp.jl")
testlines = split("""light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.""", "\n")
testlines2 = split("""shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.""", "\n")
lines = split(day(6), "\n")
hasgoldbag = Dict()

bagrules = Dict(map(lines) do line
    bag, ob = split(line, "s contain ")
    if contains(ob, "no other bags") 
        bag => Dict()
    else
        otherbags = split(replace(ob, r"s{0,1}\." => ""), r"s{0,1}, ")
        bag => Dict(map(otherbags) do otherbag
            number, name = split(otherbag, " ", limit=2)
            name => parse(Int, number)
        end)
    end
end)

function hgb!(hasgoldbag, bagrules, bagname) 
    bagsinside = keys(get(bagrules, bagname, Dict()))
    if get(hasgoldbag, bagname, false)
        true
    else
        mightbeinthere = if "shiny gold bag" in bagsinside
            true
        elseif length(bagsinside) > 0
            any(hgb!(hasgoldbag, bagrules, baginside) for baginside in bagsinside)
        else
            false
        end
        push!(hasgoldbag, bagname => mightbeinthere)
        mightbeinthere
    end
end

function f!(hasgoldbag, bagrules) 
    for rule in bagrules
        hgb!(hasgoldbag, bagrules, rule.first)
    end
end

function s(rule, bagrules)::Bool
    key = rule.first
    rulekeys = get(bagrules, key, Dict())
    any([contains(r.first, "shiny gold") for r in rulekeys]) || any([s(r, bagrules) for r in rulekeys])
end

function sjekk(bagrules) 
    kake = [s(x, bagrules) for x in bagrules]
    count(kake)
end

function numberofbagsingoldbag(bagrules, bagname)::Int64
    innerbags = get(bagrules, bagname, Dict())
    if length(innerbags) == 0 
        println(bagname)
        return 0
    end
    return sum(collect(values(innerbags))) + 
    sum(map(collect(innerbags)) do rule 
        rule.second * numberofbagsingoldbag(bagrules, rule.first)
    end)
end


numberofbagsingoldbag(bagrules, "shiny gold bag")
