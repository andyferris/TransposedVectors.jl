@testset "Multiplication" begin
    v = [1,2,3]
    tv = v.'
    mat = diagm([1,2,3])

    @test (tv*v) === 14
    @test (tv*mat)::TransposedVector == [1 4 9]
    @test_throws Exception [1]*reshape([1],(1,1)) # no longer permitted
    @test_throws Exception tv*tv
    @test (v*tv)::Matrix == [1 2 3; 2 4 6; 3 6 9]
    @test_throws Exception v*v # Was previously a missing method error, now an error message
    @test_throws Exception mat*tv

    @test_throws Exception tv*v.'
    @test (tv*mat.')::TransposedVector == [1 4 9]
    @test_throws Exception [1]*reshape([1],(1,1)).' # no longer permitted
    @test tv*tv.' === 14
    @test_throws Exception v*tv.'
    @test (v*v.')::Matrix == [1 2 3; 2 4 6; 3 6 9]
    @test (mat*tv.')::Vector == [1,4,9]

end
