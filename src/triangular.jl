# Methods to resolve ambiguities with `AbstractTriangular`
@inline *(tvec::TransposedVector, trimat::LinAlg.AbstractTriangular) = transpose(trimat * transpose(tvec))
@inline *(::LinAlg.AbstractTriangular, ::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

@inline A_mul_Bt(tvec::TransposedVector, mat::LinAlg.AbstractTriangular) = transpose(mat * transpose(tvec))
@inline A_mul_Bt(mat::LinAlg.AbstractTriangular, tvec::TransposedVector) = mat * transpose(tvec)

@inline At_mul_Bt(mat::LinAlg.AbstractTriangular, tvec::TransposedVector) = mat.' * transpose(tvec)
@inline At_mul_Bt(tvec::TransposedVector, mat::LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline At_mul_B(mat::LinAlg.AbstractTriangular, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")
@inline At_mul_B(tvec::TransposedVector, mat::LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline A_mul_Bc(tvec::TransposedVector, mat::LinAlg.AbstractTriangular) = ctranspose(mat * ctranspose(tvec))
@inline A_mul_Bc(mat::LinAlg.AbstractTriangular, tvec::TransposedVector) = mat * ctranspose(tvec)

@inline Ac_mul_Bc(mat::LinAlg.AbstractTriangular, tvec::TransposedVector) = mat' * ctranspose(tvec)
@inline Ac_mul_Bc(tvec::TransposedVector, mat::LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline Ac_mul_B(mat::LinAlg.AbstractTriangular, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")
@inline Ac_mul_B(tvec::TransposedVector, mat::LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline /(tvec::TransposedVector, tri::Union{UpperTriangular,LowerTriangular}) = transpose(transpose(tri) \ transpose(tvec))
@inline /(tvec::TransposedVector, tri::Union{LinAlg.UnitUpperTriangular,LinAlg.UnitLowerTriangular}) = transpose(transpose(tri) \ transpose(tvec))

@inline A_rdiv_Bt(tvec::TransposedVector, tri::Union{UpperTriangular,LowerTriangular}) = transpose(tri \ transpose(tvec))
@inline A_rdiv_Bt(tvec::TransposedVector, tri::Union{LinAlg.UnitUpperTriangular,LinAlg.UnitLowerTriangular}) = transpose(tri \ transpose(tvec))

@inline A_rdiv_Bc(tvec::TransposedVector, tri::Union{UpperTriangular,LowerTriangular}) = ctranspose(tri \ ctranspose(tvec))
@inline A_rdiv_Bc(tvec::TransposedVector, tri::Union{LinAlg.UnitUpperTriangular,LinAlg.UnitLowerTriangular}) = ctranspose(tri \ ctranspose(tvec))

@inline \(::Union{UpperTriangular,LowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline \(::Union{LinAlg.UnitUpperTriangular,LinAlg.UnitLowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")

@inline At_ldiv_B(::Union{UpperTriangular,LowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline At_ldiv_B(::Union{LinAlg.UnitUpperTriangular,LinAlg.UnitLowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")

@inline Ac_ldiv_B(::Union{UpperTriangular,LowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline Ac_ldiv_B(::Union{LinAlg.UnitUpperTriangular,LinAlg.UnitLowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
