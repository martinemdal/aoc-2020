using HTTP
function day(day::Int64, session="<session token>") 
    if !isfile("day$day.txt")
        println("fetching file for day$day")
        g = String(HTTP.request("GET", "https://adventofcode.com/2020/day/$day/input"; cookies=Dict("session" => session)).body)

        session
        write("day$day.txt", g)
    end
    read("day$day.txt", String)
end