@testset "QR ambiguity methods" begin
    qrmat = Base.LinAlg.getq(qrfact(eye(3)))
    v = [2,3,4]
    tv = v.'

    @test (tv*qrmat')::TransposedVector == [2 3 4]
end
