
@inline Base.:(\)(::SparseMatrixCSC, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")

@inline Base.Ac_ldiv_B(L::Base.SparseArrays.CHOLMOD.FactorComponent, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
