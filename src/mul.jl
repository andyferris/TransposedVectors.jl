# TODO deal with mapreduce wierdness, JuliaLang/julia#19308
# (current implementation is non-optimal)

# TODO see if we can optimize away the allocating calls to conj()


@inline Base.:(*)(tvec::TransposedVector, vec::AbstractVector) = reduce(+, map(At_mul_B, transpose(tvec), vec))
@inline Base.:(*)(tvec::TransposedVector, mat::AbstractMatrix) = transpose(mat.' * transpose(tvec))
@inline Base.:(*)(vec::AbstractVector, mat::AbstractMatrix) = error("Cannot left-multiply a matrix by a vector") # Should become a deprecation
@inline Base.:(*)(::TransposedVector, ::TransposedVector) = error("Cannot multiply two transposed vectors")
@inline Base.:(*)(vec::AbstractVector, tvec::TransposedVector) = kron(vec, tvec)
@inline Base.:(*)(vec::AbstractVector, tvec::AbstractVector) = error("Cannot multiply two vectors")
@inline Base.:(*)(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

# Transposed forms
@inline Base.A_mul_Bt(::TransposedVector, ::AbstractVector) = error("Cannot multiply two transposed vectors")
@inline Base.A_mul_Bt(tvec::TransposedVector, mat::AbstractMatrix) = transpose(mat * transpose(tvec))
@inline Base.A_mul_Bt(vec::AbstractVector, mat::AbstractMatrix) = error("Cannot left-multiply a matrix by a vector")
@inline Base.A_mul_Bt(tvec1::TransposedVector, tvec2::TransposedVector) = reduce(+, map(At_mul_B, transpose(tvec1), transpose(tvec2)))
@inline Base.A_mul_Bt(vec::AbstractVector, tvec::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.A_mul_Bt(vec1::AbstractVector, vec2::AbstractVector) = kron(vec1, transpose(vec2))
@inline Base.A_mul_Bt(mat::AbstractMatrix, tvec::TransposedVector) = mat * transpose(tvec)

@inline Base.At_mul_Bt(tvec::TransposedVector, vec::AbstractVector) = kron(transpose(vec), transpose(tvec))
@inline Base.At_mul_Bt(tvec::TransposedVector, mat::AbstractMatrix) = error("Cannot left-multiply matrix by vector")
@inline Base.At_mul_Bt(vec::AbstractVector, mat::AbstractMatrix) = transpose(mat * vec)
@inline Base.At_mul_Bt(tvec1::TransposedVector, tvec2::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.At_mul_Bt(vec::AbstractVector, tvec::TransposedVector) = reduce(+, map(At_mul_B, vec, transpose(tvec)))
@inline Base.At_mul_Bt(vec::AbstractVector, tvec::AbstractVector) = error("Cannot multiply two transposed vectors")
@inline Base.At_mul_Bt(mat::AbstractMatrix, tvec::TransposedVector) = mat.' * transpose(tvec)

@inline Base.At_mul_B(::TransposedVector, ::AbstractVector) = error("Cannot multiply two vectors")
@inline Base.At_mul_B(tvec::TransposedVector, mat::AbstractMatrix) = error("Cannot left-multiply matrix by vector")
@inline Base.At_mul_B(vec::AbstractVector, mat::AbstractMatrix) = transpose(At_mul_B(mat,vec))
@inline Base.At_mul_B(tvec1::TransposedVector, tvec2::TransposedVector) = kron(transpose(tvec1), tvec2)
@inline Base.At_mul_B(vec::AbstractVector, tvec::TransposedVector) = error("Cannot multiply two transposed vectors")
@inline Base.At_mul_B{T<:Real}(vec1::AbstractVector{T}, vec2::AbstractVector{T}) = reduce(+, map(At_mul_B, vec1, vec2)) # Seems to be overloaded...
@inline Base.At_mul_B(vec1::AbstractVector, vec2::AbstractVector) = reduce(+, map(At_mul_B, vec1, vec2))
@inline Base.At_mul_B(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

# Conjugated forms
@inline Base.A_mul_Bc(::TransposedVector, ::AbstractVector) = error("Cannot multiply two transposed vectors")
@inline Base.A_mul_Bc(tvec::TransposedVector, mat::AbstractMatrix) = ctranspose(mat * ctranspose(tvec))
@inline Base.A_mul_Bc(vec::AbstractVector, mat::AbstractMatrix) = error("Cannot left-multiply a matrix by a vector")
@inline Base.A_mul_Bc(tvec1::TransposedVector, tvec2::TransposedVector) = reduce(+, map(A_mul_Bc, tvec1, tvec2))
@inline Base.A_mul_Bc(vec::AbstractVector, tvec::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.A_mul_Bc(vec1::AbstractVector, vec2::AbstractVector) = kron(vec1, ctranspose(vec2))
@inline Base.A_mul_Bc(mat::AbstractMatrix, tvec::TransposedVector) = mat * ctranspose(tvec)

@inline Base.Ac_mul_Bc(tvec::TransposedVector, vec::AbstractVector) = kron(ctranspose(vec), ctranspose(tvec))
@inline Base.Ac_mul_Bc(tvec::TransposedVector, mat::AbstractMatrix) = error("Cannot left-multiply matrix by vector")
@inline Base.Ac_mul_Bc(vec::AbstractVector, mat::AbstractMatrix) = ctranspose(mat * vec)
@inline Base.Ac_mul_Bc(tvec1::TransposedVector, tvec2::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.Ac_mul_Bc(vec::AbstractVector, tvec::TransposedVector) = reduce(+, map(Ac_mul_Bc, vec, transpose(tvec)))
@inline Base.Ac_mul_Bc(vec::AbstractVector, tvec::AbstractVector) = error("Cannot multiply two transposed vectors")
@inline Base.Ac_mul_Bc(mat::AbstractMatrix, tvec::TransposedVector) = mat' * ctranspose(tvec)

@inline Base.Ac_mul_B(::TransposedVector, ::AbstractVector) = error("Cannot multiply two vectors")
@inline Base.Ac_mul_B(tvec::TransposedVector, mat::AbstractMatrix) = error("Cannot left-multiply matrix by vector")
@inline Base.Ac_mul_B(vec::AbstractVector, mat::AbstractMatrix) = ctranspose(Ac_mul_B(mat,vec))
@inline Base.Ac_mul_B(tvec1::TransposedVector, tvec2::TransposedVector) = kron(ctranspose(tvec1), tvec2)
@inline Base.Ac_mul_B(vec::AbstractVector, tvec::TransposedVector) = error("Cannot multiply two transposed vectors")
@inline Base.Ac_mul_B(vec1::AbstractVector, vec2::AbstractVector) = reduce(+, map(Ac_mul_B, vec1, vec2))
@inline Base.Ac_mul_B(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

#=
#A_mul_B!
#Ac_mul_B!
#Ac_mul_B!
#At_mul_B!
#Ac_mul_B!
#Ac_mul_Bc!
#At_mul_Bt!

#Ac_ldiv_B!
#A_ldiv_B!
#At_ldiv_B!
#etc
=#
