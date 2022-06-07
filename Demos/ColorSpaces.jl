import NeuralTests as n
using Colors




function base_net(N_gradient::Int64 = 100)
    net = n.Network()
    in_names = ["in_R1","in_G1","in_B1","in_R2","in_G2","in_B2"]
    [n.add_node!(net,name) for name in in_names]

    for i in 1:N_gradient
        n.add_node!(net,"out_R$i")
        n.add_node!(net,"out_G$i")
        n.add_node!(net,"out_B$i")
        for in_name ∈ in_names
            for c ∈ ["R","G","B"]
                n.add_edge!(net,in_name,"out_$c$i",1.0)
            end
        end
    end
    return net
end

test_net = base_net(10);

in_nodes = n.get_nodes(test_net,"in_");
input = Dict{n.Node,Float64}()
output = n.get_nodes(test_net,"out_");
[merge!(input,Dict(in_node=>1.0)) for in_node in in_nodes];

values(n.compute_neural_net(test_net,input,output))