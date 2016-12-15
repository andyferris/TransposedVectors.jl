@testset "Ambiguities" begin
    @test isempty(Base.Test.detect_ambiguities(TransposedVectors, Base, Core))
end

@testset "Core" begin
    v = [1,2,3]
    z = [1+im,2,3]

    @test TransposedVector(v) == [1 2 3]
    @test TransposedVector{Int}(v) == [1 2 3]
    @test size(TransposedVector{Int}(3)) === (1,3)
    @test size(TransposedVector{Int}(1,3)) === (1,3)
    @test size(TransposedVector{Int}((3,))) === (1,3)
    @test size(TransposedVector{Int}((1,3))) === (1,3)
    @test_throws Exception TransposedVector{Float64, Vector{Int}}(v)

    @test (v.')::TransposedVector == [1 2 3]
    @test (v')::TransposedVector == [1 2 3]
    @test (z.')::TransposedVector == [1+im 2 3]
    @test (z')::TransposedVector == [1-im 2 3]

    tv = v.'
    tz = z.'

    @test (tv.')::Vector == [1, 2, 3]
    @test (tv')::Vector == [1, 2, 3]
    @test (tz.')::Vector == [1+im, 2, 3]
    @test (tz')::Vector == [1-im, 2, 3]

    @test conj(tv) === tv
    @test conj(tz) == [1-im 2 3]

    @test isa(similar(tv), TransposedVector)
    @test isa(similar(tv, Float64), TransposedVector)
    @test isa(copy(tv), TransposedVector)

    @test tv[2] === v[2]
    @test tv[1,2] === v[2]

    @test (tv2 = copy(tv); tv2[2] = 6; tv2[2] === 6)
    @test (tv2 = copy(tv); tv2[1,2] = 6; tv2[2] === 6)

    @test length(tv) === 3
    @test size(tv) === (1,3)
    @test size(tv,1) === 1
    @test size(tv,2) === 3

    @test map(-, tv)::TransposedVector == [-1 -2 -3]
    @test (-).(tv)::TransposedVector == [-1 -2 -3]
    @test (-).(tv,1)::TransposedVector == [0  1  2]

    @test AbstractVector(tv)::Vector{Int} == [1, 2, 3]
    @test Vector{Float64}(tv)::Vector{Float64} == [1, 2, 3]
    @test TransposedVector{Float64,Vector{Float64}}(tv)::TransposedVector{Float64} == [1.0  2.0  3.0]

    y = rand(Complex{Float64},3)
    @test sumabs2(imag.(diag(y .+ y'))) < 1e-20
end
