# TransposedVectors

*A package which takes vector transposes seriously (for Julia v0.5)*

[![Build Status](https://travis-ci.org/andyferris/TransposedVectors.jl.svg?branch=master)](https://travis-ci.org/andyferris/TransposedVectors.jl)

[![Coverage Status](https://coveralls.io/repos/andyferris/TransposedVectors.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/andyferris/TransposedVectors.jl?branch=master)

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
