module TransposedVectors

import Base: transpose, ctranspose, conj, size, length, similar

import Base: @propagate_inbounds

export TransposedVector

include("TransposedVector.jl")
include("mul.jl")
include("ldiv.jl")
include("rdiv.jl")
include("diagonal.jl")
include("triangular.jl")
include("sparse.jl")

end # module
