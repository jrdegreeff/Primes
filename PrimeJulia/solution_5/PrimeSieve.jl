const validation_dict = Dict{Int64, Int64}(
    10 => 4,
    100 => 25,
    1000 => 168,
    10000 => 1229,
    100000 => 9592,
    1000000 => 78498,
    10000000 => 664579,
    100000000 => 5761455
)

struct Sieve
    size::Int64
    bits::BitVector

    Sieve(size::Int64) = new(size, trues(size))
end

function run_sieve!(sieve::Sieve)
    sieve.bits[1] = false
    sieve.bits[4:2:sieve.size] .= false
    
    factor = 3
    q = ceil(Int64, sqrt(sieve.size))

    while factor < q
        for num in (factor * factor):2factor:sieve.size
            sieve.bits[num] = false
        end
        for num in (factor+2):2:sieve.size
            if sieve.bits[num]
                factor = num
                break
            end
        end
    end
end

count_primes(sieve::Sieve) = sum(sieve.bits)
validate(sieve::Sieve) = haskey(validation_dict, sieve.size) && validation_dict[sieve.size] == count_primes(sieve)

function printResults(sieve::Sieve, show_results::Bool, duration::Float64, passes::Int64)
    show_results && println(join((i for (i, b) in enumerate(sieve.bits) if b), ", "))
    
    println("Passes: $passes, Time: $(duration)s, Avg: $(duration / passes)s, Limit: $(sieve.size), Count: $(count_primes(sieve)), Valid: $(validate(sieve))")
    println()
    println("jrdegreeff;$passes;$duration;1;algorithm=base,faithful=yes,bits=1")
end

function main()
    passes = 0
    size = 1000000
    local sieve

    start = time()
    while (time() - start < 5)
        sieve = Sieve(size)
        run_sieve!(sieve)
        passes += 1
    end

    printResults(sieve, false, time() - start, passes)
end

main()
