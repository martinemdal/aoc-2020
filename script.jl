using HTTP

data() = "{ \"data\": 123 }"
other() = "{ \"other\": true }"
default() = "{}"

function route(path, routingDict::Dict) 
    println("Got request for $path")
    return get(routingDict, path, default)()
end
 
println("Starting API")
HTTP.listen("127.0.0.1", 8081) do http
    HTTP.setheader(http, "Content-Type" => "application/json")
    write(http, route(http.message.target, Dict( "/data" => data, "/other" => other)))
    return
end