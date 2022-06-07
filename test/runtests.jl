import NeuralTests as n
using Test

Node1 = n.Node("Node1")
Node2 = n.Node("Node2")
Edge1 = n.Edge(Node1,Node2)
net_auto = n.Network(Set([Node1,Node2]),Set([Edge1]),Dict(Edge1=>5.0))
n.connect_network!(net_auto)

# Manually add edges to nodes to check if auto works
Node1.edges = Set([Edge1])
Node2.edges = Set([Edge1])
net = n.Network(Set([Node1,Node2]),Set([Edge1]),Dict(Edge1=> 5.0))

Node3 = n.Node("Node3")
Edge2 = n.Edge(Node1,Node3)
push!(Node1.edges,Edge2)
push!(Node3.edges,Edge2)
bad_net = n.Network(Set([Node1,Node2]),Set([Edge1,Edge2]),Dict(Edge1=>5.0,Edge2=>6.0))

new_net = deepcopy(net)
n.add_node!(new_net,"lil_guy")
n.add_edge!(new_net,"lil_guy","Node1",5.0)

@testset "NeuralTests.jl" begin
    @test get(new_net.weights,n.get_edges(new_net,"lil_guy","Node1"),"Not Found")==5
    @test n.network_check(bad_net)=="Edges out of bounds"
    @test [x for x in net_auto.weights]==[x for x in net.weights]
end
