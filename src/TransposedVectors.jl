module TransposedVectors

import Base: transpose, ctranspose, conj, size, length

import Base: @propagate_inbounds

export TransposedVector

include("TransposedVector.jl")

end # module
