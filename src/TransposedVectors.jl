module TransposedVectors

import Base: transpose, ctranspose, conj, size, length, similar, norm, getindex,
       setindex!, convert, map, broadcast, linearindexing, LinearFast, promote_op,
       LinAlg, SparseArrays, hcat, typed_hcat, vcat, typed_vcat, hvcat_fill, promote_typeof

import Base: *, A_mul_Bt, At_mul_B, At_mul_Bt, A_mul_Bc, Ac_mul_B, Ac_mul_Bc
import Base: /, A_rdiv_Bt, At_rdiv_B, At_rdiv_Bt, A_rdiv_Bc, Ac_rdiv_B, Ac_rdiv_Bc
import Base: \, A_ldiv_Bt, At_ldiv_B, At_ldiv_Bt, A_ldiv_Bc, Ac_ldiv_B, Ac_ldiv_Bc

import Base: @propagate_inbounds, @pure

export TransposedVector, transpose_type

include("TransposedVector.jl")
include("hcat.jl")
include("mul.jl")
include("ldiv.jl")
include("rdiv.jl")
include("diagonal.jl")
include("triangular.jl")
include("sparse.jl")
include("qr.jl")
include("norm.jl")

end # module
