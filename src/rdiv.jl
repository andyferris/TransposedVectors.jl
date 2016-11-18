# Right division
@inline Base.:(/)(tvec::TransposedVector, mat::AbstractMatrix) = TransposedVector(mat \ tvec.vec)
#A_rdiv_Bc
#A_rdiv_Bt
#Ac_rdiv_B
#Ac_rdiv_Bc
#At_rdiv_B
#At_rdiv_Bt
