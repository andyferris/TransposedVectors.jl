# Left division
@inline Base.:(\)(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot left-divide transposed vector by matrix")
#A_ldiv_Bc
#A_ldiv_Bt
#Ac_ldiv_B
#Ac_ldiv_Bc
#At_ldiv_B
#At_ldiv_Bt
