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

# similar()
@inline similar(tvec::TransposedVector) = TransposedVector(similar(tvec.vec))
@inline similar{T}(tvec::TransposedVector, ::Type{T}) = TransposedVector(similar(tvec.vec, T))
# There is no resizing similar() because it would be ambiguous if the result were a Matrix or a TransposedVector

# Basic methods
@inline transpose(vec::AbstractVector) = TransposedVector(vec)
@inline ctranspose{T}(vec::AbstractVector{T}) = TransposedVector(conj(vec))
@inline ctranspose{T<:Real}(vec::AbstractVector{T}) = TransposedVector(vec)

@inline transpose(tvec::TransposedVector) = tvec.vec
@inline ctranspose{T}(tvec::TransposedVector{T}) = conj(tvec.vec)
@inline ctranspose{T<:Real}(tvec::TransposedVector{T}) = tvec.vec

# Strictly, these are unnecessary but will make things stabler if we introduce
# a "view" for conj(::AbstractArray)
@inline conj(tvec::TransposedVector) = TransposedVector(conj(tvec.vec))
@inline conj{T<:Real}(tvec::TransposedVector{T}) = tvec

# AbstractArray interface
@inline length(tvec::TransposedVector) =  length(tvec.vec)
@inline size(tvec::TransposedVector) = (1, length(tvec.vec))
@inline size(tvec::TransposedVector, d) = ifelse(d==2, length(tvec.vec), 1)
Base.linearindexing{V<:TransposedVector}(::Union{V,Type{V}}) = Base.LinearFast()

@propagate_inbounds Base.getindex(tvec::TransposedVector, i) = transpose(tvec.vec[i])
@propagate_inbounds Base.setindex!(tvec::TransposedVector, v, i) = setindex!(tvec.vec, transpose(v), i)

# Cartesian indexing is distorted by getindex
@inline function Base.getindex(tvec::TransposedVector, i::CartesianIndex{2}) # TODO generalize to arbitrary dimension CartesianIndex
    @boundscheck if !(i.I[1] == 1 && i.I[2] ∈ indices(tvec.vec)[1])
        throw(BoundsError(tvec, i.I))
    end
    @inbounds return transpose(tvec.vec[i.I[2]])
end
@inline function Base.setindex!(tvec::TransposedVector, v, i::CartesianIndex{2})
    @boundscheck if !(i.I[1] == 1 && i.I[2] ∈ indices(tvec.vec)[1])
        throw(BoundsError(tvec, i.I))
    end
    @inbounds tvec.vec[i.I[2]] = transpose(v)
end


# Some conversions
Base.convert(::Type{AbstractVector}, tvec::TransposedVector) = tvec.vec
Base.convert{V<:AbstractVector}(::Type{V}, tvec::TransposedVector) = convert(V, tvec.vec)
Base.convert{T,V}(::Type{TransposedVector{T,V}}, tvec::TransposedVector) = TransposedVector(convert(V, tvec.vec))

# helper function for below
@inline to_vec(tvec::TransposedVector) = transpose(tvec)
@inline to_vec(x::Number) = x
@inline to_vecs(tvecs...) = (map(to_vec, tvecs)...)

# map
@inline Base.map(f, tvecs::TransposedVector...) = TransposedVector(map(f, to_vecs(tvecs...)...))

# broacast
@inline Base.broadcast(f, tvecs::Union{Number,TransposedVector}...) = TransposedVector(broadcast(f, to_vecs(tvecs...)...))
# Other combinations default to Array...
