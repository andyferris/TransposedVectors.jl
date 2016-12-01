# Methods to resolve ambiguities with `AbstractTriangular`
@inline Base.:(*)(tvec::TransposedVector, trimat::Base.LinAlg.AbstractTriangular) = TransposedVector(trimat * tvec.vec)
@inline Base.:(*)(::Base.LinAlg.AbstractTriangular, ::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

@inline Base.A_mul_Bt(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = TransposedVector(mat * tvec.vec)
@inline Base.A_mul_Bt(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = mat * tvec.vec

@inline Base.At_mul_Bt(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = mat.' * tvec.vec
@inline Base.At_mul_Bt(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline Base.At_mul_B(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")
@inline Base.At_mul_B(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline Base.A_mul_Bc(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = conj(TransposedVector(mat * conj(tvec.vec)))
@inline Base.A_mul_Bc(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = mat * conj(tvec.vec)

@inline Base.Ac_mul_Bc(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = mat' * conj(tvec.vec)
@inline Base.Ac_mul_Bc(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")

@inline Base.Ac_mul_B(mat::Base.LinAlg.AbstractTriangular, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")
@inline Base.Ac_mul_B(tvec::TransposedVector, mat::Base.LinAlg.AbstractTriangular) = error("Cannot left-multiply matrix by vector")


@inline Base.:(/)(tvec::TransposedVector, tri::Union{UpperTriangular,LowerTriangular}) = TransposedVector(tri \ tvec.vec)
@inline Base.:(/)(tvec::TransposedVector, tri::Union{Base.LinAlg.UnitUpperTriangular,Base.LinAlg.UnitLowerTriangular}) = TransposedVector(tri \ tvec.vec)

@inline Base.:(\)(::Union{UpperTriangular,LowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline Base.:(\)(::Union{Base.LinAlg.UnitUpperTriangular,Base.LinAlg.UnitLowerTriangular}, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
