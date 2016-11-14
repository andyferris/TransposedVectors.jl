immutable TransposedVector{T,V<:AbstractVector} <: AbstractMatrix{T}
    vec::V
    function TransposedVector(v::V)
        check_types(T,v)
        new(v)
    end
end

check_types{T}(::Type{T},::AbstractVector{T}) = nothing
check_types(T,v) = error("Element type mismatch. Tried to create a `TransposedVector{$T}` from a $(typeof(v))")

# Constructors that take a vector
@inline TransposedVector{T}(vec::AbstractVector{T}) = TransposedVector{T,typeof(vec)}(vec)
@inline (::Type{TransposedVector{T}}){T}(vec::AbstractVector{T}) = TransposedVector{T,typeof(vec)}(vec)

# Constructors that take a size and default to Array
@inline (::Type{TransposedVector{T}}){T}(n::Int) = TransposedVector{T}(Vector{T}(n))
@inline (::Type{TransposedVector{T}}){T}(n1::Int, n2::Int) = n1 == 1 ? TransposedVector{T}(Vector{T}(n2)) : error("TransposedVector expects 1×N size, got ($n1,$n2)")
@inline (::Type{TransposedVector{T}}){T}(n::Tuple{Int}) = TransposedVector{T}(Vector{T}(n[1]))
@inline (::Type{TransposedVector{T}}){T}(n::Tuple{Int,Int}) = n[1] == 1 ? TransposedVector{T}(Vector{T}(n[2])) : error("TransposedVector expects 1×N size, got $n")

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

Base.convert(::Type{AbstractVector}, tvec::TransposedVector) = tvec.vec

# TODO deal with mapreduce wierdness, JuliaLang/julia#19308
# (current implementation is non-optimal)

# TODO see if we can optimize away the allocating calls to conj()

@inline Base.:(*)(tvec::TransposedVector, vec::AbstractVector) = reduce(+, map(+, tvec.vec, vec))
@inline Base.:(*)(tvec::TransposedVector, mat::AbstractMatrix) = TransposedVector(mat.' * tvec.vec)
@inline Base.:(*)(vec::AbstractVector, mat::AbstractMatrix) = error("Cannot left-multiply a matrix by a vector") # Should become a deprecation
@inline Base.:(*)(::TransposedVector, ::TransposedVector) = error("Cannot multiply two transposed vectors")
@inline Base.:(*)(vec::AbstractVector, tvec::TransposedVector) = kron(vec, tvec)
@inline Base.:(*)(vec::AbstractVector, tvec::AbstractVector) = error("Cannot multiply two vectors")
@inline Base.:(*)(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

# Transposed forms
@inline Base.A_mul_Bt(::TransposedVector, ::AbstractVector) = error("Cannot multiply two transposed vectors")
@inline Base.A_mul_Bt(tvec::TransposedVector, mat::AbstractMatrix) = TransposedVector(mat * tvec.vec)
@inline Base.A_mul_Bt(vec::AbstractVector, mat::AbstractMatrix) = error("Cannot left-multiply a matrix by a vector")
@inline Base.A_mul_Bt(tvec1::TransposedVector, tvec2::TransposedVector) = reduce(+, map(*, tvec1.vec, tvec2.vec))
@inline Base.A_mul_Bt(vec::AbstractVector, tvec::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.A_mul_Bt(vec1::AbstractVector, vec2::AbstractVector) = kron(vec1, vec2.')
@inline Base.A_mul_Bt(mat::AbstractMatrix, tvec::TransposedVector) = mat * tvec.vec

@inline Base.At_mul_Bt(tvec::TransposedVector, vec::AbstractVector) = kron(tvec, vec)
@inline Base.At_mul_Bt(tvec::TransposedVector, mat::AbstractMatrix) = error("Cannot left-multiply matrix by vector")
@inline Base.At_mul_Bt(vec::AbstractVector, mat::AbstractMatrix) = TransposedVector(mat * vec)
@inline Base.At_mul_Bt(tvec1::TransposedVector, tvec2::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.At_mul_Bt(vec::AbstractVector, tvec::TransposedVector) = reduce(+, map(*, vec, tvec.vec))
@inline Base.At_mul_Bt(vec::AbstractVector, tvec::AbstractVector) = error("Cannot multiply two transposed vectors")
@inline Base.At_mul_Bt(mat::AbstractMatrix, tvec::TransposedVector) = mat.' * tvec.vec

@inline Base.At_mul_B(::TransposedVector, ::AbstractVector) = error("Cannot multiply two vectors")
@inline Base.At_mul_B(tvec::TransposedVector, mat::AbstractMatrix) = error("Cannot left-multiply matrix by vector")
@inline Base.At_mul_B(vec::AbstractVector, mat::AbstractMatrix) = TransposedVector(At_mul_B(mat,vec))
@inline Base.At_mul_B(tvec1::TransposedVector, tvec2::TransposedVector) = kron(tvec1.vec, tvec2)
@inline Base.At_mul_B(vec::AbstractVector, tvec::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.At_mul_B{T<:Real}(vec1::AbstractVector{T}, vec2::AbstractVector{T}) = reduce(+, map(*, vec1, vec2)) # Seems to be overloaded...
@inline Base.At_mul_B(vec1::AbstractVector, vec2::AbstractVector) = reduce(+, map(*, vec1, vec2))
@inline Base.At_mul_B(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

# Conjugated forms
@inline Base.A_mul_Bc(::TransposedVector, ::AbstractVector) = error("Cannot multiply two transposed vectors")
@inline Base.A_mul_Bc(tvec::TransposedVector, mat::AbstractMatrix) = TransposedVector(mat * conj(tvec.vec))
@inline Base.A_mul_Bc(vec::AbstractVector, mat::AbstractMatrix) = error("Cannot left-multiply a matrix by a vector")
@inline Base.A_mul_Bc(tvec1::TransposedVector, tvec2::TransposedVector) = reduce(+, map(((a,b) -> a * conj(b)), tvec1.vec, tvec2.vec))
@inline Base.A_mul_Bc(vec::AbstractVector, tvec::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.A_mul_Bc(vec1::AbstractVector, vec2::AbstractVector) = kron(vec1, vec2')
@inline Base.A_mul_Bc(mat::AbstractMatrix, tvec::TransposedVector) = mat * conj(tvec.vec)

@inline Base.Ac_mul_Bc(tvec::TransposedVector, vec::AbstractVector) = kron(conj(tvec), conj(vec))
@inline Base.Ac_mul_Bc(tvec::TransposedVector, mat::AbstractMatrix) = error("Cannot left-multiply matrix by vector")
@inline Base.Ac_mul_Bc(vec::AbstractVector, mat::AbstractMatrix) = conj(TransposedVector(mat * vec))
@inline Base.Ac_mul_Bc(tvec1::TransposedVector, tvec2::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.Ac_mul_Bc(vec::AbstractVector, tvec::TransposedVector) = reduce(+, map(((a,b) -> conj(a * b)), vec, tvec.vec))
@inline Base.Ac_mul_Bc(vec::AbstractVector, tvec::AbstractVector) = error("Cannot multiply two transposed vectors")
@inline Base.Ac_mul_Bc(mat::AbstractMatrix, tvec::TransposedVector) = mat' * conj(tvec.vec)

@inline Base.Ac_mul_B(::TransposedVector, ::AbstractVector) = error("Cannot multiply two vectors")
@inline Base.Ac_mul_B(tvec::TransposedVector, mat::AbstractMatrix) = error("Cannot left-multiply matrix by vector")
@inline Base.Ac_mul_B(vec::AbstractVector, mat::AbstractMatrix) = TransposedVector(conj(Ac_mul_B(mat,vec)))
@inline Base.Ac_mul_B(tvec1::TransposedVector, tvec2::TransposedVector) = kron(conj(tvec1.vec), tvec2)
@inline Base.Ac_mul_B(vec::AbstractVector, tvec::TransposedVector) = error("Cannot multiply two vectors")
@inline Base.Ac_mul_B(vec1::AbstractVector, vec2::AbstractVector) = reduce(+, map(((a,b) -> conj(a) * b), vec1, vec2))
@inline Base.Ac_mul_B(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot right-multiply matrix by transposed vector")

# Right division
@inline Base.:(/)(tvec::TransposedVector, mat::AbstractMatrix) = TransposedVector(mat \ tvec.vec)
#A_rdiv_Bc
#A_rdiv_Bt
#Ac_rdiv_B
#Ac_rdiv_Bc
#At_rdiv_B
#At_rdiv_Bt

# Left division
@inline Base.:(\)(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot left-divide transposed vector by matrix")
#A_ldiv_Bc
#A_ldiv_Bt
#Ac_ldiv_B
#Ac_ldiv_Bc
#At_ldiv_B
#At_ldiv_Bt

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

# helper function
@inline to_vecs(tvecs::TransposedVector...) = (map(AbstractVector, tvecs)...)

# map
@inline Base.map(f, tvecs::TransposedVector...) = TransposedVector(map(f, to_vecs(tvecs...)...))

# broacast
@inline Base.broadcast(f, tvecs::TransposedVector...) = TransposedVector(broadcast(f, to_vecs(tvecs...)...))
