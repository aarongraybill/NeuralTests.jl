using MLDatasets

# load full training set
train_x, train_y = MNIST.traindata()

using Plots


rots = similar(train_x);
for (ind,val) ∈ pairs(train_x)
    img_num = ind[3]
    new_ind = Vector{Int64}([[0, 1] [-1,0]]*([ind[1],ind[2]].-29/2).+29/2)
    rots[new_ind[1],new_ind[2],img_num] = val
end

heatmap(rots[:,:,10], 
#color = :greys,
aspect_ratio=1)

import NeuralTests as n
net=n.Network();

out_dict = Dict{n.Node,Float64}()
for i ∈ 1:9
    temp_node = n.add_node!(net,"out_$i",0.0)
    push!(out_dict,temp_node=>0.0);
end

for ind ∈ CartesianIndices(Array{Float64}(undef, 28, 28))
    temp_node = n.add_node!(net,"in_$ind",0.0,out_dict);
end

