# Right division
@inline /(tvec::TransposedVector, mat::AbstractMatrix) = transpose(transpose(mat) \ transpose(tvec))

# Base only has specializations of A_rdiv_Bc and A_rdiv_Bt
@inline A_rdiv_Bt(tvec::TransposedVector, mat::AbstractMatrix) = transpose(mat \ transpose(tvec))

@inline A_rdiv_Bc(tvec::TransposedVector, mat::AbstractMatrix) = ctranspose(mat  \ ctranspose(tvec))

# These others fall back to applying the transpose, which is perfect for us:
#   Ac_rdiv_B
#   Ac_rdiv_Bc
#   At_rdiv_B
#   At_rdiv_Bt
