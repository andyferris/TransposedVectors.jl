# Methods to resolve ambiguities with `Diagonal`
@inline Base.:(*)(tvec::TransposedVector, diagonal::Diagonal) = transpose(diagonal * transpose(tvec))
@inline Base.:(*)(::Diagonal, ::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

@inline Base.A_mul_Bt(d::Diagonal, tvec::TransposedVector) = d*transpose(tvec)

@inline Base.At_mul_B(tvec::TransposedVector, d::Diagonal) = error("Cannot left-multiply matrix by vector")

@inline Base.A_mul_Bc(d::Diagonal, tvec::TransposedVector) = d*ctranspose(tvec)

@inline Base.Ac_mul_B(tvec::TransposedVector, d::Diagonal) = error("Cannot left-multiply matrix by vector")

@inline Base.:(\)(::Diagonal, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline Base.:(\)(::Bidiagonal, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline Base.:(\){TA<:Number,TB<:Number}(::Bidiagonal{TA}, ::TransposedVector{TB}) = error("Cannot left-divide matrix by transposed vector")

@inline Base.At_ldiv_B(::Bidiagonal, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline Base.At_ldiv_B{TA<:Number,TB<:Number}(::Bidiagonal{TA}, ::TransposedVector{TB}) = error("Cannot left-divide matrix by transposed vector")

@inline Base.Ac_ldiv_B(::Bidiagonal, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline Base.Ac_ldiv_B{TA<:Number,TB<:Number}(::Bidiagonal{TA}, ::TransposedVector{TB}) = error("Cannot left-divide matrix by transposed vector")
