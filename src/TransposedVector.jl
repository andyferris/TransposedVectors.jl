immutable TransposedVector{T,V<:AbstractVector} <: AbstractMatrix{T}
    vec::V
    function TransposedVector(v::V)
        check_types(T,v)
        new(v)
    end
end

@pure check_types{T1,T2}(::Type{T1},::AbstractVector{T2}) = transpose_type(T1) === transpose_type(T2) ? nothing : error("Element type mismatch. Tried to create a `TransposedVector{$T}` from a $(typeof(v))")

# The element type is transformed as transpose is recursive
@inline transpose_type{T}(::Type{T}) = promote_op(transpose, T)

# Constructors that take a vector
@inline TransposedVector{T}(vec::AbstractVector{T}) = TransposedVector{transpose_type(T),typeof(vec)}(vec)
@inline (::Type{TransposedVector{T}}){T}(vec::AbstractVector{T}) = TransposedVector{T,typeof(vec)}(vec)

# Constructors that take a size and default to Array
@inline (::Type{TransposedVector{T}}){T}(n::Int) = TransposedVector{T}(Vector{transpose_type(T)}(n))
@inline (::Type{TransposedVector{T}}){T}(n1::Int, n2::Int) = n1 == 1 ? TransposedVector{T}(Vector{transpose_type(T)}(n2)) : error("TransposedVector expects 1×N size, got ($n1,$n2)")
@inline (::Type{TransposedVector{T}}){T}(n::Tuple{Int}) = TransposedVector{T}(Vector{transpose_type(T)}(n[1]))
@inline (::Type{TransposedVector{T}}){T}(n::Tuple{Int,Int}) = n[1] == 1 ? TransposedVector{T}(Vector{transpose_type(T)}(n[2])) : error("TransposedVector expects 1×N size, got $n")

# similar()
@inline similar(tvec::TransposedVector) = TransposedVector(similar(tvec.vec))
@inline similar{T}(tvec::TransposedVector, ::Type{T}) = TransposedVector(similar(tvec.vec, transpose_type(T)))
# There is no resizing similar() because it would be ambiguous if the result were a Matrix or a TransposedVector

# Basic methods
@inline transpose(vec::AbstractVector) = TransposedVector(vec)
@inline ctranspose{T}(vec::AbstractVector{T}) = TransposedVector(conj(vec))
@inline ctranspose{T<:Real}(vec::AbstractVector{T}) = TransposedVector(vec)

@inline transpose(tvec::TransposedVector) = tvec.vec
@inline ctranspose{T}(tvec::TransposedVector{T}) = conj(tvec.vec)
@inline ctranspose{T<:Real}(tvec::TransposedVector{T}) = tvec.vec

# Some overloads from Base
@inline transpose(r::Range) = TransposedVector(r)
@inline transpose(bv::BitVector) = TransposedVector(bv)
@inline transpose(sv::SparseVector) = TransposedVector(sv)

@inline ctranspose(r::Range) = TransposedVector(conj(r)) # is there such a thing as a complex range?
@inline ctranspose(bv::BitVector) = TransposedVector(bv)
@inline ctranspose(sv::SparseVector) = TransposedVector(conj(sv))

# Strictly, these are unnecessary but will make things stabler if we introduce
# a "view" for conj(::AbstractArray)
@inline conj(tvec::TransposedVector) = TransposedVector(conj(tvec.vec))
@inline conj{T<:Real}(tvec::TransposedVector{T}) = tvec

# AbstractArray interface
@inline length(tvec::TransposedVector) =  length(tvec.vec)
@inline size(tvec::TransposedVector) = (1, length(tvec.vec))
@inline size(tvec::TransposedVector, d) = ifelse(d==2, length(tvec.vec), 1)
linearindexing{V<:TransposedVector}(::Union{V,Type{V}}) = LinearFast()

@propagate_inbounds getindex(tvec::TransposedVector, i) = transpose(tvec.vec[i])
@propagate_inbounds setindex!(tvec::TransposedVector, v, i) = setindex!(tvec.vec, transpose(v), i)

# Cartesian indexing is distorted by getindex
# Furthermore, Cartesian indexes don't have to match shape, apparently!
@inline function getindex(tvec::TransposedVector, i::CartesianIndex)
    @boundscheck if !(i.I[1] == 1 && i.I[2] ∈ indices(tvec.vec)[1] && check_tail_indices(i.I...))
        throw(BoundsError(tvec, i.I))
    end
    @inbounds return transpose(tvec.vec[i.I[2]])
end
@inline function setindex!(tvec::TransposedVector, v, i::CartesianIndex)
    @boundscheck if !(i.I[1] == 1 && i.I[2] ∈ indices(tvec.vec)[1] && check_tail_indices(i.I...))
        throw(BoundsError(tvec, i.I))
    end
    @inbounds tvec.vec[i.I[2]] = transpose(v)
end

@propagate_inbounds getindex(tvec::TransposedVector, ::CartesianIndex{0}) = getindex(tvec)
@propagate_inbounds getindex(tvec::TransposedVector, i::CartesianIndex{1}) = getindex(tvec, i.I[1])

@propagate_inbounds setindex!(tvec::TransposedVector, v, ::CartesianIndex{0}) = setindex!(tvec, v)
@propagate_inbounds setindex!(tvec::TransposedVector, v, i::CartesianIndex{1}) = setindex!(tvec, v, i.I[1])

@inline check_tail_indices(i1, i2) = true
@inline check_tail_indices(i1, i2, i3, is...) = i3 == 1 ? check_tail_indices(i1, i2, is...) :  false

# Some conversions
convert(::Type{AbstractVector}, tvec::TransposedVector) = tvec.vec
convert{V<:AbstractVector}(::Type{V}, tvec::TransposedVector) = convert(V, tvec.vec)
convert{T,V}(::Type{TransposedVector{T,V}}, tvec::TransposedVector) = TransposedVector(convert(V, tvec.vec))

# helper function for below
@inline to_vec(tvec::TransposedVector) = transpose(tvec)
@inline to_vec(x::Number) = x
@inline to_vecs(tvecs...) = (map(to_vec, tvecs)...)

# map
@inline map(f, tvecs::TransposedVector...) = TransposedVector(map(f, to_vecs(tvecs...)...))

# broacast
@inline broadcast(f, tvecs::Union{Number,TransposedVector}...) = TransposedVector(broadcast(f, to_vecs(tvecs...)...))
# Other combinations default to Array...
