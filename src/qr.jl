@inline A_mul_Bc(tvec::TransposedVector, B::Union{LinAlg.QRCompactWYQ,LinAlg.QRPackedQ}) = ctranspose(B*ctranspose(tvec))
