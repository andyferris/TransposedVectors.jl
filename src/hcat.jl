# Empty hcat defaults to row vector
hcat() = [].'
typed_hcat{T}(::Type{T}) = typed_vcat(T).'

hcat{T}(X::T...)         = T[ X[j] for j=1:length(X) ].'
hcat{T<:Number}(X::T...) = T[ X[j] for j=1:length(X) ].'

hcat(X::Number...) = hvcat_fill(Array{promote_typeof(X...),1}(length(X)), X).'
typed_hcat{T}(::Type{T}, X::Number...) = hvcat_fill(Array{T,1}(length(X)), X).'

hcat(X::TransposedVector...) = vcat(map(transpose, X)...).'
hcat(X::Union{TransposedVector,Number}...) = vcat(map(transpose, X)...).'
