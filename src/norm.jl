norm{T}(tv::TransposedVector{T}) = norm(tv.vec)
norm{T}(tv::TransposedVector{T}, p::Real) = norm(tv.vec, p)
