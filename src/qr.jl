@inline Base.A_mul_Bc(tvec::TransposedVector, B::Union{Base.LinAlg.QRCompactWYQ,Base.LinAlg.QRPackedQ}) = TransposedVector(conj(B*conj(tvec.vec)))
