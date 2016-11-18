@testset "Right Division" begin
    mat = diagm([1,2,3])
    v = [2,3,4]
    tv = v.'

    @test (tv/mat)::TransposedVector ≈ [2/1  3/2  4/3]
end
