@testset "AbstractTriangular ambiguity methods" begin
    ut = UpperTriangular([1 0 0; 0 2 0; 0 0 3])
    v = [2,3,4]
    tv = v.'

    @test (tv*ut)::TransposedVector == [2 6 12]
    @test_throws Exception ut*tv

    @test (tv*ut.')::TransposedVector == [2 6 12]
    @test (ut*tv.')::Vector == [2,6,12]

    @test (ut.'*tv.')::Vector == [2,6,12]
    @test_throws Exception tv.'*ut.'

    @test_throws Exception ut.'*tv
    @test_throws Exception tv.'*ut

    @test (tv*ut')::TransposedVector == [2 6 12]
    @test (ut*tv')::Vector == [2,6,12]

    @test (tv/ut)::TransposedVector ≈ [2/1  3/2  4/3]

    @test_throws Exception ut\tv

end
