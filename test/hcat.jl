@testset "hcat" begin
    @test isa(hcat(), TransposedVector{Any})
    @test isa(Base.typed_hcat(Int), TransposedVector{Int})

    @test isa([1 2 3], TransposedVector{Int})
    @test isa(Float64[1 2 3], TransposedVector{Float64})

    @test isa([1 2 3.0], TransposedVector{Float64})
    @test isa(Float32[1 2 3.0], TransposedVector{Float32})

    @test isa([[1 2 3] 4], TransposedVector{Int})
    @test isa([[1 2 3] [4 5]], TransposedVector{Int})

end
