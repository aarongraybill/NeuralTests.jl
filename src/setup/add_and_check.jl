using NeuralTests

"""
Check for various network problems
"""
function network_check(net::Network)
    out_string=""
    if length(net.edges)>0
        used_nodes=reduce(vcat,[[edge.origin ,edge.target] for edge in net.edges]) 
        if used_nodes ⊈ net.nodes
            out_string="$(out_string)Edges out of bounds"
        end 
        keys(net.weights) ⊆ net.edges ? nothing : out_string="$out_string, ∃ Weight for an edge that DNE"
        keys(net.weights) ⊇ net.edges ? nothing : out_string="$out_string, ∃ Edge for a weight that DNE"
    end
    return out_string
end


"""
Return all nodes of the given pattern

for example if you have "NodeA" "NodeB" and "kumquat" as the opt text 
    in your network, get_nodes(net,"Node") would only returrn those first two
"""
function get_nodes(net::Network,opt_text::String)
    out_set = Set{Node}()
    for node ∈ net.nodes
        occursin(opt_text,node.opt_text) ? push!(out_set,node) : nothing
    end
    if length(out_set)==1
        out_set = pop!(out_set)
    end
    return out_set
end

function get_edges(net::Network,opt_text_orig::String,opt_text_targ::String)
    out_set = Set{Edge}()
    for edge ∈ net.edges
        occursin(opt_text_orig,edge.origin.opt_text) && occursin(opt_text_targ,edge.target.opt_text) ? push!(out_set,edge) : nothing
    end 
    if length(out_set)==1
        out_set = pop!(out_set)
    end
    return out_set
end

function get_weight(net::Network,orig_node::Node,targ_node::Node)
    @assert [orig_node,targ_node] ⊆ net.nodes
    out_val = missing
    for (edge,val) ∈ net.weights
       edge.origin==orig_node && edge.target == targ_node ? out_val = val : nothing
    end
    return out_val
end

"""
Add a node to an existing network.

You should never really add a node if it's not the input or output of something else,
    but I don't require it in case this is the first node in the network

I create any necessary edges implied by function input

"""
function add_node!(
    net::Network,
    opt_text::String="",
    bias::Float64=0.0,
    node_is_target_of::Dict{Node,Float64}=Dict{Node,Float64}(),
    node_is_origin_for::Dict{Node,Float64}=Dict{Node,Float64}())
    @assert keys(node_is_origin_for) ⊆ net.nodes
    @assert keys(node_is_target_of) ⊆ net.nodes

    new_node = Node(opt_text)
    for (targ,weight) in node_is_origin_for
        new_edge = Edge(new_node,targ)
        push!(net.edges,new_edge)
        merge!(net.weights,Dict(new_edge=>weight))
        targ.edges = push!(targ.edges,new_edge)
        new_node.edges = push!(new_node.edges,new_edge)
    end

    for (orig,weight) in node_is_target_of
        new_edge = Edge(orig,new_node)
        push!(net.edges,new_edge)
        merge!(net.weights,Dict(new_edge=>weight))
        orig.edges = push!(orig.edges,new_edge)
        new_node.edges = push!(new_node.edges,new_edge)
    end

    push!(net.nodes,new_node)
    merge!(net.biases,Dict(new_node=>bias)) 
    return new_node
end

function add_node!(
    net::Network,
    opt_text::String="",
    bias::Float64=0.0,
    node_is_target_of::Union{Array{Tuple{String,Float64}},Missing}=missing,
    node_is_origin_for::Union{Array{Tuple{String,Float64}},Missing}=missing)

    orig_dict = Dict{Node,Float64}()
    targ_dict = Dict{Node,Float64}()

    if !ismissing(node_is_origin_for)
        for (text,val) ∈ node_is_origin_for
            temp = get_nodes(net,text)
            merge!(orig_dict,Dict(temp=>val))
        end
    end

    if !ismissing(node_is_target_of)
        for (text,val) ∈ node_is_target_of
            temp = get_nodes(net,text)
            merge!(targ_dict,Dict(temp=>val))
        end
    end

    add_node!(net,opt_text::String,bias,targ_dict,orig_dict)
end



function connect_network!(net::Network)
    for (edge,value) ∈ net.weights
        if edge ∉ edge.origin.edges
            push!(edge.origin.edges,edge)
        end
        if edge ∉ edge.target.edges
            push!(edge.target.edges,edge)
        end
    end
end

"""
Add or update an edge, requires a value for a weight
"""
function add_edge!(net::Network,origin::Node,target::Node,weight::Float64)
    @assert origin ∈ net.nodes
    @assert target ∈ net.nodes
    new_edge = Edge(origin,target)
    merge!(net.weights,Dict(new_edge=>weight))
    push!(origin.edges,new_edge)
    push!(target.edges,new_edge)
    push!(net.edges,new_edge)
end


function add_edge!(net::Network,origin::String,target::String,weight::Float64)
    origin = get_nodes(net,origin)
    target = get_nodes(net,target)
    add_edge!(net,origin,target,weight)
end
