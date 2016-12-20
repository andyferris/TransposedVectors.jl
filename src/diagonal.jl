# Methods to resolve ambiguities with `Diagonal`
@inline *(tvec::TransposedVector, diagonal::Diagonal) = transpose(diagonal * transpose(tvec))
@inline *(::Diagonal, ::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

@inline A_mul_Bt(d::Diagonal, tvec::TransposedVector) = d*transpose(tvec)

@inline At_mul_B(tvec::TransposedVector, d::Diagonal) = error("Cannot left-multiply matrix by vector")

@inline A_mul_Bc(d::Diagonal, tvec::TransposedVector) = d*ctranspose(tvec)

@inline Ac_mul_B(tvec::TransposedVector, d::Diagonal) = error("Cannot left-multiply matrix by vector")

@inline \(::Diagonal, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline \(::Bidiagonal, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline \{TA<:Number,TB<:Number}(::Bidiagonal{TA}, ::TransposedVector{TB}) = error("Cannot left-divide matrix by transposed vector")

@inline At_ldiv_B(::Bidiagonal, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline At_ldiv_B{TA<:Number,TB<:Number}(::Bidiagonal{TA}, ::TransposedVector{TB}) = error("Cannot left-divide matrix by transposed vector")

@inline Ac_ldiv_B(::Bidiagonal, ::TransposedVector) = error("Cannot left-divide matrix by transposed vector")
@inline Ac_ldiv_B{TA<:Number,TB<:Number}(::Bidiagonal{TA}, ::TransposedVector{TB}) = error("Cannot left-divide matrix by transposed vector")
