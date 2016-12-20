# Left division
@inline \(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot left-divide transposed vector by matrix")

# These four are trivial definitions in Base, resorting to transposition:
#   A_ldiv_Bc
#   A_ldiv_Bt
#   At_ldiv_Bt
#   Ac_ldiv_Bc

# The others need to be overloaded...
@inline At_ldiv_B(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot left-divide transposed vector by matrix")
@inline Ac_ldiv_B(mat::AbstractMatrix, tvec::TransposedVector) = error("Cannot left-divide transposed vector by matrix")
