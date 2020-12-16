#            "X10XX01"   "X10XX01"   "X10XX01"
# bitstring(0b0100001 | 0b1011000 & 0b1101101)
# # X                     1101001
# 0b0 | 0b0 & 0b1
# 0b0 | 0b1 & 0b1

# # 1
# 0b1 | 0b0 & 0b1
# 0b1 | 0b1 & 0b1

# # 0
# 0b0 | 0b0 & 0b0
# 0b0 | 0b1 & 0b0

n = 5

function maskfunction(mask) 
    or, and = mapslices(e -> parse(UInt64, join(e), base=2), 
        mapreduce(c -> c == 'X' ? [0 1] : c == '1' ? [1 1] : [0 0], vcat, collect(mask)),
    dims=1)
    x -> or | x & and
end

masker = maskfunction("X10XX01")
bitstring(masker(parse(UInt64, "1011000", base=2)))