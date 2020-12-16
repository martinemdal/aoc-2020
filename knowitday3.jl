input = """vlzzrkytiempkxg
wkuwuuniimpuzka
ufrazcavumtagod
ooscwzmvscdngwe
lskokdozvxvecer
povfkarkkmgoovf
vlirgaldqisatsg
pvknfgayzgqkcnn
iekozvnabdyapva
zgllegiizobkyjl
lgukatmaltamzba
lvnrvdizullcvsx
oscponrepvyatzy
rbhovtkpfljkihq
wjssiksnnergnal"""

using Test

ord = ["kakao", "kriminalroman", "kvikklunch", "kylling", "langfredag", "langrennski", "palmesøndag", "påskeegg", "smågodt", "solvegg", "yatzy"]
function finn(ord, matrise) 
    onedim = split(replace(matrise, r"\n" => ""), "")
    sidelength = (isqrt ∘ length)(onedim)
    M = reshape(onedim, sidelength, sidelength)
    u = union(
    map(1:sidelength) do j 
        join(map(1:sidelength - j) do i
            M[i + j, i]
        end)
    end,
    map(1:sidelength) do j 
        join(map((1 + j):sidelength) do i
            M[i - j, i]
        end)
    end,
    join(map(1:sidelength) do i
        M[i, sidelength - i + 1]
    end),
    map(0:sidelength) do j 
        join(map(1:(sidelength - j)) do i
            M[i, (sidelength - j) - i + 1]
        end)
    end,
    map(1:sidelength) do j 
        join(map(1:sidelength - j) do i
            M[i + j, (sidelength) - i + 1]
        end)
    end,
    mapslices(join, M, dims=1),
    mapslices(join, M, dims=2))
    U = union(filter(x -> length(x) > 1, u), map(reverse, filter(x -> length(x) > 1, u)))
    filter(o -> !any(x -> contains(x, o), U), ord)
end

finn(ord, input)
@test finn(ord, input) == ["palmesøndag","påskeegg","smågodt"]

rord = ["nisseverksted",
"pepperkake",
"adventskalender",
"klementin",
"krampus",
"juletre",
"julestjerne",
"gløggkos",
"marsipangris",
"mandel",
"sledespor",
"nordpolen",
"nellik",
"pinnekjøtt",
"svineribbe",
"lutefisk",
"medisterkake",
"grevinne",
"hovmester",
"sølvgutt",
"jesusbarnet",
"julestrømpe",
"askepott",
"rudolf",
"akevitt"]

println(sort(finn(rord, read("input.txt", String))))