@testset "norm" begin
   @test norm([3.0,4.0].') ≈ 5.0
   @test norm([3.0,4.0].', 1) ≈ 4.0
   @test norm([3.0,4.0].', Inf) ≈ 7.0
end
