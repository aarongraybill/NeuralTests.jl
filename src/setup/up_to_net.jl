using NeuralTests

"""
The basic building block of a neural network. A `Node` connects to other `Node`s through an `Edge` along with a weight
"""
@kwdef mutable struct Node
    edges;
    opt_text::String = nothing
end

"""
An `Edge` has a `origin` `Node`, a `target` `Node`, and an associated `weight` which tells you the transformation from one node to the next
"""
@kwdef mutable struct Edge
    origin
    target
end

function Node()
    return Node(Set{Edge}(),"")
end

function Node(opt_text::String)
    return Node(Set{Edge}(),opt_text)
end

edges!(n::Node) = n.edges::Set{Edge}
origin!(e::Edge) = e.origin::Node
target!(e::Edge) = e.target::Node

@kwdef mutable struct Network
    nodes::Set{Node} = Set{Node}()
    edges::Set{Edge} = Set{Edge}()
    weights::Dict{Edge,Float64} = Dict{Edge,Float64}()
    function Network(nodes::Set{Node},edges::Set{Edge},weights::Dict{Edge,Float64})
        [edges!(node) for node in nodes]
        [origin!(edge) for edge in edges]
        [target!(edge) for edge in edges]
        #retype the edges and nodes appropriately
        new(nodes,edges,weights)
    end
end