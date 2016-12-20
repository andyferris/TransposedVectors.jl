
@inline \(::SparseMatrixCSC, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")

@inline Ac_ldiv_B(L::SparseArrays.CHOLMOD.FactorComponent, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
