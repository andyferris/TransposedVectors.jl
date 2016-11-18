
@inline Base.:(\)(::SparseMatrixCSC, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
