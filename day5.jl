include("adventofcodehttp.jl")
input = day(5)
groups = split(input, "\n\n")

reduce(+, map(groups) do group
    chars = replace(group, r"\s+" => "")
    length(Set(split(chars, "")))
end)

reduce(+, map(groups) do group
    members = split(group, "\n")
    membersets= map(members) do member 
        Set(split(member, ""))
    end
    is = reduce(intersect, membersets)
    length(is)
end)