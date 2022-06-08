"""

This file contanis a brief example of how networks in this package are intended to be constructed

The general framework is:

1. Create a blank network using Network()
2. Add nodes via add_node! with unique id text
3. 

"""

import NeuralTests as n

net = n.Network()
n.add_node!(net,"input",0.0)
n.add_node!(net,"output1",0.0)
n.add_edge!(net,"input","output1",5.0) # ensure these strings uniquely identify a node
n.add_node!(net,"output2",0.0)
n.add_node!(net,"hidden",0.0,[("input",1.0)],[("output1",1.5),("output2",2.5)])


# if you're usinig nodes directly, they can also be called, this will be much more efficient
#n.add_edge!(net,n.get_nodes(net,"input"),n.get_nodes(net,"output"),5.0)

simple_net = n.Network()
n.add_node!(simple_net,"input1",0.0)
n.add_node!(simple_net,"input2",0.0)
n.add_node!(simple_net,"outputA",0.0)
n.add_node!(simple_net,"outputB",1.0) #notice the bias

n.add_edge!(simple_net,"input1","outputA",1.0)
n.add_edge!(simple_net,"input1","outputB",2.0)
n.add_edge!(simple_net,"input2","outputB",3.0)


inputs = Dict(
    n.get_nodes(simple_net,"input1")=>1.0,
n.get_nodes(simple_net,"input2")=>2.0)

outputs = n.get_nodes(simple_net,"output")

values(n.compute_neural_net(simple_net,inputs,outputs))

# hidden_net = n.Network()
# n.add_node!(hidden_net,"input1")
# n.add_node!(hidden_net,"input2")
# n.add_node!(hidden_net,"hidden")
# n.add_node!(hidden_net,"output")
# n.add_edge!(hidden_net,"input1","hidden",1.0)
# n.add_edge!(hidden_net,"input2","hidden",3.0)
# n.add_edge!(hidden_net,"hidden","output",2.0)
# n.add_edge!(hidden_net,"input2","output",4.0)

# inputs_bypass = Dict(
# n.get_nodes(hidden_net,"hidden")=>99.0,
# n.get_nodes(hidden_net,"input1")=>1.0,
# n.get_nodes(hidden_net,"input2")=>10.0
# )
# inputs = Dict(
# n.get_nodes(hidden_net,"input1")=>1.0,
# n.get_nodes(hidden_net,"input2")=>10.0
# )
# outputs = n.get_nodes(hidden_net,"output")

# #notice that feeding the network an intermediate value allows it to skip previous layers (in this case getting the wrong answer)
#     # because it was fed the wrong hidden value
# values(n.compute_neural_net(hidden_net,inputs,Set([outputs])))
# values(n.compute_neural_net(hidden_net,inputs_bypass,Set([outputs])))
