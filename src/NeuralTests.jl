"""
A novice's attempt to build neural networks from scratch
"""
module NeuralTests

using Base: @kwdef
using Parameters

# Folder that constructs neural nets but doesn't compute them

include("setup/up_to_net.jl")

include("setup/add_and_check.jl") 

include("setup/compute_neural_net.jl")

end

