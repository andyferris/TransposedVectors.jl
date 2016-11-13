immutable TransposedVector{T,V<:AbstractVector} <: AbstractMatrix{T}
    vec::V
    function TransposedVector(v::V)
        check_types(T,v)
        new(v)
    end
end

check_types{T}(::Type{T},::AbstractVector{T}) = nothing
check_types(T,v) = error("Element type mismatch. Tried to create a `TransposedVector{$T}` from a $(typeof(v))")

@inline TransposedVector{T}(vec::AbstractVector{T}) = TransposedVector{T,typeof(vec)}(vec)
@inline (::Type{TransposedVector{T}}){T}(vec::AbstractVector{T}) = TransposedVector{T,typeof(vec)}(vec)

@inline transpose(vec::AbstractVector) = TransposedVector(vec)
@inline ctranspose(vec::AbstractVector) = TransposedVector(conj(vec))

@inline transpose(vec::TransposedVector) = vec.vec
@inline ctranspose(vec::TransposedVector) = conj(vec.vec)

@inline conj(vec::TransposedVector) = TransposedVector(conj(vec.vec))

@inline length(vec::TransposedVector) =  length(vec.vec)
@inline size(vec::TransposedVector) = (1, length(vec.vec))
@inline size(vec::TransposedVector,d) = ifelse(d==2, length(vec.vec), 1)
Base.linearindexing{V<:TransposedVector}(::Union{V,Type{V}}) = Base.LinearFast()

@propagate_inbounds Base.getindex(vec::TransposedVector, i) = vec.vec[i]
@propagate_inbounds Base.setindex!(vec::TransposedVector, v, i) = setindex!(vec.vec, v, i)

# TODO deal with mapreduce bug JuliaLang/julia#19308

@inline Base.:(*)(tvec::TransposedVector, vec::AbstractVector) = reduce(+, map(+, tvec.vec, vec))
@inline Base.:(*)(tvec::TransposedVector, mat::AbstractMatrix) = TransposedVector(mat.' * tvec.vec)
@inline Base.:(*)(vec::AbstractVector, mat::AbstractMatrix) = error("Cannot left-multiply a matrix by a vector") # Should become a deprecation
@inline Base.:(*)(::TransposedVector, ::TransposedVector) = error("Cannot multiply two transposed vectors")
@inline Base.:(*)(vec::AbstractVector, tvec::TransposedVector) = kron(vec, tvec)
@inline Base.:(*)(vec::AbstractVector, tvec::AbstractVector) = error("Cannot multiply two vectors")
@inline Base.:(*)(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

@inline Base.A_mul_Bt(::TransposedVector, ::AbstractVector) = error("Cannot multiply two transposed vectors")
@inline Base.A_mul_Bt(tvec::TransposedVector, mat::AbstractMatrix) = TransposedVector(mat * tvec.vec)
@inline Base.A_mul_Bt(vec::AbstractVector, mat::AbstractMatrix) = error("Cannot left-multiply a matrix by a vector")
@inline Base.A_mul_Bt(tvec1::TransposedVector, tvec2::TransposedVector) = reduce(+, map(+, tvec1.vec, tvec2.vec))
@inline Base.A_mul_Bt(vec::AbstractVector, tvec::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.A_mul_Bt(vec1::AbstractVector, vec2::AbstractVector) = kron(vec1, vec2.')
@inline Base.A_mul_Bt(mat::AbstractMatrix, tvec::TransposedVector) = mat * tvec.vec

@inline Base.At_mul_Bt(tvec::TransposedVector, vec::AbstractVector) = kron(tvec, vec)
@inline Base.At_mul_Bt(tvec::TransposedVector, mat::AbstractMatrix) = error("Cannot left-multiply matrix by vector")
@inline Base.At_mul_Bt(vec::AbstractVector, mat::AbstractMatrix) = TransposedVector(mat * vec)
@inline Base.At_mul_Bt(tvec1::TransposedVector, tvec2::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.At_mul_Bt(vec::AbstractVector, tvec::TransposedVector) = reduce(+, map(+, vec, tvec.vec))
@inline Base.At_mul_Bt(vec::AbstractVector, tvec::AbstractVector) = error("Cannot multiply two transposed vectors")
@inline Base.At_mul_Bt(mat::AbstractMatrix, tvec::TransposedVector) = mat.' * tvec.vec

@inline Base.At_mul_B(::TransposedVector, ::AbstractVector) = error("Cannot multiply two vectors")
@inline Base.At_mul_B(tvec::TransposedVector, mat::AbstractMatrix) = error("Cannot left-multiply matrix by vector")
@inline Base.At_mul_B(vec::AbstractVector, mat::AbstractMatrix) = TransposedVector(At_mul_B(mat,vec))
@inline Base.At_mul_B(tvec1::TransposedVector, tvec2::TransposedVector) = kron(tvec1.vec, tvec2)
@inline Base.At_mul_B(vec::AbstractVector, tvec::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.At_mul_B(vec1::AbstractVector, vec2::AbstractVector) = reduce(+, map(+, vec1, vec2))
@inline Base.At_mul_B(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

#At_mul_B
#Ac_mul_B
#A_mul_Bc
#Ac_mul_Bc
