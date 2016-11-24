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

    @test (tv.'*v.')::Matrix == [1 2 3; 2 4 6; 3 6 9]
    @test_throws Exception tv.'*mat.'
    @test (v.'*mat.')::TransposedVector == [1 4 9]
    @test_throws Exception tv.'*tv.'
    @test v.'*tv.' === 14
    @test_throws Exception v.'*v.'
    @test (mat.'*tv.')::Vector == [1,4,9]

    @test_throws Exception tv.'*v
    @test_throws Exception tv.'*mat
    @test (v.'*mat)::TransposedVector == [1 4 9]
    @test (tv.'*tv)::Matrix == [1 2 3; 2 4 6; 3 6 9]
    @test_throws Exception v.'*tv
    @test v.'*v === 14
    @test_throws Exception mat.'*tv

    z = [1+im,2,3]
    cz = z'
    mat = diagm([1+im,2,3])

    @test cz*z === 15 + 0im

    @test_throws Exception cz*z'
    @test (cz*mat')::TransposedVector == [-2im 4 9]
    @test_throws Exception [1]*reshape([1],(1,1))' # no longer permitted
    @test cz*cz' === 15 + 0im
    @test_throws Exception z*vz'
    @test (z*z')::Matrix == [2 2+2im 3+3im; 2-2im 4 6; 3-3im 6 9]
    @test (mat*cz')::Vector == [2im,4,9]

    @test (cz'*z')::Matrix == [2 2+2im 3+3im; 2-2im 4 6; 3-3im 6 9]
    @test_throws Exception cz'*mat'
    @test (z'*mat')::TransposedVector == [-2im 4 9]
    @test_throws Exception cz'*cz'
    @test z'*cz' === 15 + 0im
    @test_throws Exception z'*z'
    @test (mat'*cz')::Vector == [2,4,9]

end
