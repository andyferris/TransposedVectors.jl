@inline norm{T}(tv::TransposedVector{T}) = norm(transpose(tv))

"""
    norm(transposed_vector, [q = 2])

Takes the q-norm of a transposed vector, which is equivalent to the p-norm with
value `p = q/(1-q)`. They coincide at `p = q = 2`.

The difference in norm between a vector space and its dual arrises to preserve
the relationship between duality and the inner product, and the result is
consistent with the p-norm of `1 × n` matrix.
"""
@inline norm{T}(tv::TransposedVector{T}, q::Real) = q == Inf ? norm(transpose(tv), 1) : norm(transpose(tv), q/(1-q))
