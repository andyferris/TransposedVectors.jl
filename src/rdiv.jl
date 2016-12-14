# Right division
@inline Base.:(/)(tvec::TransposedVector, mat::AbstractMatrix) = TransposedVector(mat \ tvec.vec)

# Base only has specializations of A_rdiv_Bc and A_rdiv_Bt
@inline Base.A_rdiv_Bt(tvec::TransposedVector, mat::AbstractMatrix) = TransposedVector(mat.' \ tvec.vec)

@inline Base.A_rdiv_Bc(tvec::TransposedVector, mat::AbstractMatrix) = TransposedVector(mat'  \ tvec.vec)

# These others fall back to applying the transpose, which is perfect for us:
#   Ac_rdiv_B
#   Ac_rdiv_Bc
#   At_rdiv_B
#   At_rdiv_Bt
