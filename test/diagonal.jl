@testset "Diagonal ambiguity methods" begin
    d = Diagonal([1,2,3])
    v = [2,3,4]
    tv = v.'

    @test (tv*d)::TransposedVector == [2,6,12].'
    @test_throws Exception d*tv

    @test (d*tv.')::Vector == [2,6,12]
    

    @test (tv/d)::TransposedVector ≈ [2/1  3/2  4/3]

    @test_throws Exception d \ tv

end

@testset "Bidiagonal ambiguity methods" begin
    bd = Bidiagonal([1,2,3], [0,0], true)
    v = [2,3,4]
    tv = v.'

    @test (tv/bd)::TransposedVector ≈ [2/1  3/2  4/3]

    @test_throws Exception bd \ tv
end
