@testset "Left Division" begin
    mat = diagm([1,2,3])
    v = [2,3,4]
    tv = v.'

    @test_throws Exception mat \ tv
end
