# Methods to resolve ambiguities with `AbstractTriangular`
@inline Base.:(*)(tvec::TransposedVector, trimat::Base.LinAlg.AbstractTriangular) = transpose(trimat * transpose(tvec))
@inline Base.:(*)(::Base.LinAlg.AbstractTriangular, ::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

@inline Base.A_mul_Bt(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = transpose(mat * transpose(tvec))
@inline Base.A_mul_Bt(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = mat * transpose(tvec)

@inline Base.At_mul_Bt(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = mat.' * transpose(tvec)
@inline Base.At_mul_Bt(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline Base.At_mul_B(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")
@inline Base.At_mul_B(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline Base.A_mul_Bc(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = ctranspose(mat * ctranspose(tvec))
@inline Base.A_mul_Bc(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = mat * ctranspose(tvec)

@inline Base.Ac_mul_Bc(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = mat' * ctranspose(tvec)
@inline Base.Ac_mul_Bc(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline Base.Ac_mul_B(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")
@inline Base.Ac_mul_B(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline Base.:(/)(tvec::TransposedVector, tri::Union{UpperTriangular,LowerTriangular}) = transpose(transpose(tri) \ transpose(tvec))
@inline Base.:(/)(tvec::TransposedVector, tri::Union{Base.LinAlg.UnitUpperTriangular,Base.LinAlg.UnitLowerTriangular}) = transpose(transpose(tri) \ transpose(tvec))

@inline Base.:A_rdiv_Bt(tvec::TransposedVector, tri::Union{UpperTriangular,LowerTriangular}) = transpose(tri \ transpose(tvec))
@inline Base.:A_rdiv_Bt(tvec::TransposedVector, tri::Union{Base.LinAlg.UnitUpperTriangular,Base.LinAlg.UnitLowerTriangular}) = transpose(tri \ transpose(tvec))

@inline Base.:A_rdiv_Bc(tvec::TransposedVector, tri::Union{UpperTriangular,LowerTriangular}) = ctranspose(tri \ ctranspose(tvec))
@inline Base.:A_rdiv_Bc(tvec::TransposedVector, tri::Union{Base.LinAlg.UnitUpperTriangular,Base.LinAlg.UnitLowerTriangular}) = ctranspose(tri \ ctranspose(tvec))

@inline Base.:(\)(::Union{UpperTriangular,LowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline Base.:(\)(::Union{Base.LinAlg.UnitUpperTriangular,Base.LinAlg.UnitLowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")

@inline Base.At_ldiv_B(::Union{UpperTriangular,LowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline Base.At_ldiv_B(::Union{Base.LinAlg.UnitUpperTriangular,Base.LinAlg.UnitLowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")

@inline Base.Ac_ldiv_B(::Union{UpperTriangular,LowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline Base.Ac_ldiv_B(::Union{Base.LinAlg.UnitUpperTriangular,Base.LinAlg.UnitLowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
