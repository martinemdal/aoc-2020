using Primes

function santapacker(antallpakker) 
    pakkenummer = 0
    pakkerlevert = 0
    while pakkenummer < antallpakker
        if 7 in digits(pakkenummer) 
            pakkenummer += prevprime(pakkenummer)
        else
            pakkerlevert += 1
        end
        pakkenummer += 1
    end
    pakkerlevert
end

santapacker(5433000)

