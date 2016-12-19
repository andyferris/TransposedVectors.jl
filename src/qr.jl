@inline Base.A_mul_Bc(tvec::TransposedVector, B::Union{Base.LinAlg.QRCompactWYQ,Base.LinAlg.QRPackedQ}) = ctranspose(B*ctranspose(tvec))
