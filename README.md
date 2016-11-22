# TransposedVectors

*A package which takes vector transposes seriously (for Julia v0.5)*

[![Build Status](https://travis-ci.org/andyferris/TransposedVectors.jl.svg?branch=master)](https://travis-ci.org/andyferris/TransposedVectors.jl)

[![Coverage Status](https://coveralls.io/repos/github/andyferris/TransposedVectors.jl/badge.svg?branch=master)](https://coveralls.io/github/andyferris/TransposedVectors.jl?branch=master)

[![codecov.io](http://codecov.io/github/andyferris/TransposedVectors.jl/coverage.svg?branch=master)](http://codecov.io/github/andyferris/TransposedVectors.jl?branch=master)

This package prototypes some ideas for [taking vector transposes seriously](https://github.com/JuliaLang/julia/issues/4774)
which are backward-compatible with Julia v0.5. The idea is to wrap the
transposition of a vector in a `TransposedVector` type, where `TransposedVector{T} <: Matrix{T}`.

The transposed vector follows a similar semantic to previously, in that it
remains a 1-by-*N* sized array. However, the fact that the first dimension is
a singleton dimension is not forgotten by the compiler, as it is when converted
to a simple `Matrix`. Thus, we can have these properties common to standard
linear (i.e. matrix and vector) algebra:

* The transpose of a transpose of a vector is a vector
* A transposed vector times a vector is the dot-product (inner product - scalar output)
* A transposed vector times a matrix is a transposed vector
* A vector times a transposed vector becomes a matrix (outer product)
* We can perform right division of a transposed vector and a matrix

There are a few other refinements, and work is in progress.

## Discussion

As can be seen from [this discussion](https://github.com/JuliaLang/julia/issues/4774),
resolving a satisfactory system for vector and matrix algebra in Julia which
includes the possibility of turning standard (column) vectors in transposed vectors
(row vectors, co-vectors, dual vectors) is not straightforward. I see a few
hiccups and I'll try cover these below.

First, let's ignore *multilinear* algebra (higher-rank tensors) and focus on the
kind of linear algebra done in first-year university with matrices and vectors
on *real* numbers. It is common to see expressions involving vectors **v**,
matrices *A* and transposed vectors **v**ᵀ, particularly the following list of operations:

  * Dot products, **v**⋅**w**, or equivalently **v**ᵀ**w**, resulting in a scalar.
  * Matrix—vector multiplication, *A***v**, giving a vector.
  * Transposed-vector—matrix multiplication, **v**ᵀ*A*, giving a transposed vector.
  * Matrix-matrix multiplication, *A**B*, resulting in a matrix.
  * Outer product **v**⊗**w**, or **vw**ᵀ, resulting in a matrix (some
    conventions would make the first expression a vector, but never the second).

For completeness: we also allow linear algebra objects to be scaled by a *scalar*
and to be added to and subtracted from each other, if they are of the same class
and have the same dimensions. For complex matrices, we often replace the "ᵀ"
with a conjugate transpose (Hermitian conjugate) "ᴴ" or superscipt "†". Some
matrices are invertible, and even if not, matrix equations can be "solved"
(depending on the values within) implying that we can give meaning to left- and
right-division operations.

Julia gets all of this right, except for the transposed vector. The points of
difference in Julia 0.5 is:

* The transpose of a vector is a matrix (there is no "transposed vector" class).
* The double-transpose of a vector is a matrix, such that (**v**ᵀ)ᵀ is not **v**.
* **v**ᵀ**w** results in a vector, not a scalar
* **v**ᵀ*A* gives a matrix (relates to the first point).

At first, this might seem like a lot of programmer effort to address what to
some will seem to be relatively minor gripes. However, combined with a matrix
transpose view, we will be able to remove the `At_mul_Bt` class of methods
entirely in the future, resulting in an equitable degree of simplification.

Some other things I've observed about the linear algebra system:

 * We are shoe-horning concepts of linear algebra into the `AbstractArray` interface.
   The "simple" linear algebra I wrote of above has three objects: (row)
   vectors, matrices, and transposed (column, dual or co-) vectors, yet we try
   to map everything into two types: `AbstractArray{T,1}` and
   `AbstractArray{T,2}`.
 * Having vector spaces represented by `AbstractArray{T,1}` seems to disallow
   a basis-free approach to linear algebra. `AbstractVector` it most certainly
   is not, but I'm not sure how useful basis-free thinking is within
   high-performance computing so *maybe* this can be forgiven (similarly for
   `AbstractMatrix` and abstract linear operators).
 * While a dual or co-vector may also be considered a vector, and may even be
   trivially isomorphic to the original vector space, that doesn't mean that
   they cannot be distinguished: the vector space and the dual space are somehow
   different, especially in how they interact with each other, and this plays
   out under multiplication. **It is much less compelling to distinguish the
   dual of a dual of a vector from the original vector, than to distinguish a
   vector from its dual.** So making dual vectors have a different type to
   standard vectors makes a certain amount of sense,
   while having `((v::Vector)')'` give a `Matrix` does not.
 * If all vectors must be `AbstactArray`s, there is little reason why a dual vector
   wouldn't conform to the `AbstractArray` interface also: its dimensions are
   known, it most likely is cheap to call `getindex` and `setindex!`, etc.
 * Standard (non-abstract) linear algebra does treat vectors a column-arrays
   and transposed vectors as row-arrays.

It is the combination of the above that makes me believe having a
1×n sized `TransposedVector{T} <: AbstractArray{T,2}` makes a lot of sense (for
now (∗)).
People who aren't mathematicians (or mathematically trained) will resonate most
strongly with a picture of row- and column-vectors and matrices, and it would be
odd for two of these to be `AbstractArray` and one not, or for the `broadcast`
behavior to not be consistent with that picture. From the software engineering
perspective, the only behavior we break is precisely the behavior we want to
break:

 * The double-transpose of a vector (**v**ᵀ)ᵀ is a vector
 * The inner product **v**ᵀ**w** is a scalar.

I can't foresee the other changes would result in much code breakage,
since we still have `transpose(::AbstractVector)` being an `AbstractMatrix` with
the same dimensions.

-----

(∗) In the future, I think a system of traits such that something could e.g.
multiply like a matrix but not be an `AbstractArray` would be preferable.
Traits might let us disentangle `AbstractArray` and linear algebra
concepts.
