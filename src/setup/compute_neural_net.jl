using NeuralTests


"""
Compute the output value of a network given a set of inputs (a `lookup_table`)

The function is relatively neat and picks up performance gains whenever possible

    1. if you happen to know intermediate values (like if you computed a more) simple network
     then you can skip straiight to the intermediate steps
    2. unnecessary nodes will not be evaluated
    3. when there are a large number of output nodes, presumably morer and more can be pulled
        from the lookup_table instead of being computed again
"""
function compute_neural_net(net::Network,lookup_table::Dict{Node,Float64},output_nodes::Set{Node})
    @assert keys(lookup_table) ⊆ net.nodes
    @assert output_nodes ⊆ net.nodes
    output_vals = Dict{Node,Float64}()
    [o.opt_text for o in output_nodes]
    for node in output_nodes
        run_sum = get(net.biases,node,missing)
        origins = setdiff([e.origin for e ∈ node.edges],[node]) #exclude nodes where you are the input

        for o_node ∈ keys(lookup_table) ∩ origins # the values we do have
            temp_val = get(lookup_table,o_node,"Value Not found")
            temp_weight = get_weight(net,o_node,node)
            run_sum = run_sum+temp_val*temp_weight
        end
        for o_node ∈ setdiff(origins,keys(lookup_table)) # the values we don't have
            temp_weight = get_weight(net,o_node,node)
            temp_val_dict = compute_neural_net(net,lookup_table,Set([o_node]))
            temp_val = get(temp_val_dict,o_node,"uh-oh")
            run_sum = run_sum+temp_weight*temp_val
        end
        merge!(lookup_table,Dict(node => run_sum))
        merge!(output_vals,Dict(node => run_sum))
    end
    return output_vals
end