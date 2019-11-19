# 2approximation.py
# Author: Aren Tyr (aren.unix@yandex.com)
#
# Date: 2019-11-19
# Version 1.0
# This program implements an approximation algorithm that uses a spanning tree
# to deliver a cycle in a graph that is no worse than, at most, 2x the optimal
# Hamiltonian length/weight of such a cycle. Since computing the optimal
# solution is infeasible for any large input /n/ vertices, this approximation
# algorithm does it linear time.

import networkx as nx
import math

# This function computes the distance between two points on an Euclidean plane.
def dist(x1, y1, x2, y2):
   return math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)

# Builds graph from coordinates
def get_graph(coordinates):
    g = nx.Graph()
    n = len(coordinates)
    for i in range(n):
        for j in range(i + 1):
            g.add_edge(i, j, weight=dist(coordinates[i][0], coordinates[i][1], coordinates[j][0], coordinates[j][1]))
    return g

# Computes cycle length
def cycle_length(g, cycle):
    # Checking that the number of vertices in the graph equals the number of vertices in the cycle.
    assert len(cycle) == g.number_of_nodes()

    weight = 0
    start_node = cycle[0]
    last_node = cycle[len(cycle)-1]

    # Tot up the weight of all the edges
    for node in range(len(cycle) - 1):
        u = cycle[node]
        v = cycle[node+1]
        weight += g[u][v]['weight']

    # Now add final edge to complete the cycle
    weight += g[last_node][start_node]['weight']

    return weight

# Finds an approximation to an optimal Hamiltonian path with no worse than 2x the optimal result
def approximation(g):

    # n is the number of vertices.
    n = g.number_of_nodes()

    # Build a /minimal/ spanning tree of the graph
    mst = nx.minimum_spanning_tree(g)

    # Grab the node list so we can add one edge to turn it back into a cycle
    mst_node_list = list(mst.nodes())

    # Make the MST a cycle again by connecting first node to last node
    # Determine the correct weight of the edge 
    first_node = mst_node_list[-1]
    last_node = mst_node_list[0]
    orig_weight = g[first_node][last_node]['weight']
    # Now add the final edge back in to convert the tree back into a cycle 
    mst.add_edge(first_node, last_node, weight = orig_weight)

    # Double edge weight for algorithm.
    # Not required as the depth first search preorder function below
    # already calculates an optimal Eulerian cycle 
    #for edge in mst.edges():
    #    source = edge[0]
    #    dest = edge[1]
    #    g[source][dest]['weight'] = 2 * (g[source][dest]['weight'])
    # You might want to use the function "nx.minimum_spanning_tree(g)"
    # which returns a Minimum Spanning Tree of the graph g

    # Convert our graph to a list of vertices, ordered by a depth first search 
    twoHapprox = list(nx.dfs_preorder_nodes(mst, 0))

    # This function/loop is redundant. Can verify that the minimal spanning tree
    # function above has no redundant nodes.
    # final_list = [twoHapprox[0]]
    # for vertex in range(len(twoHapprox)-1):
    #     if twoHapprox[vertex+1] in final_list:
    #         print("Skipping node " + str(twoHapprox[vertex+1] + " , already visited."))
    #         continue
    #     final_list.append(twoHapprox[vertex+1])
    # print(final_list)

    print("Path taken for a 2-Approximation of Hamiltonian cycle: ")
    print(twoHapprox)
    twoHapproxWeight = cycle_length(g, twoHapprox)
    print("Cycle weight/length: " + str(twoHapproxWeight))

    # Return calculated weight/length of cycle
    return twoHapproxWeight

# Some test data 
coordinates = [(145, 176), (185, 244), (67, 192), (5, 137), (165, 154), (106, 286), (132, 173), (285, 143), (164, 115), (41, 181), (27, 137), (242, 190), (56, 208), (126, 240), (269, 221), (166, 43), (98, 296), (290, 194), (146, 67), (27, 138), (68, 283), (110, 42), (252, 41), (7, 219), (262, 205), (136, 251), (184, 240), (251, 29), (50, 148), (185, 299), (172, 106), (164, 198), (28, 88), (4, 236), (75, 42), (259, 158), (21, 38), (298, 277), (46, 97), (71, 1), (210, 173), (71, 296), (74, 227), (230, 136), (148, 278), (197, 257), (226, 29), (154, 258), (102, 162), (197, 274), (74, 12), (87, 102), (276, 65), (14, 60), (81, 184), (129, 49), (45, 68), (119, 61), (201, 45), (35, 14), (134, 173), (199, 218), (269, 233), (53, 78), (171, 167), (267, 123), (291, 245), (252, 202), (101, 262), (54, 250), (219, 300), (209, 7), (125, 230), (25, 90), (0, 144), (98, 7), (254, 94), (111, 78), (48, 175), (35, 207), (208, 192), (132, 37), (236, 97), (240, 211), (298, 265), (160, 153), (235, 279), (29, 53), (251, 213), (17, 169), (62, 11), (75, 20), (4, 115), (92, 4), (227, 61), (290, 41), (66, 15), (68, 224), (69, 265), (195, 88), (194, 129), (73, 129), (143, 119), (219, 28), (170, 260), (199, 51), (31, 300), (64, 138), (2, 100), (166, 13), (268, 131), (176, 131), (125, 283), (145, 41), (90, 208), (251, 136), (220, 142), (277, 278), (130, 228), (169, 263), (190, 207), (44, 15), (295, 162), (259, 209), (39, 2), (218, 129), (41, 203), (48, 12), (161, 20), (154, 263), (233, 205), (116, 190), (272, 289), (234, 109), (31, 100), (208, 61), (128, 25), (103, 205), (101, 159), (274, 255), (169, 22), (2, 202), (292, 240), (276, 133), (283, 94), (226, 31), (75, 247), (180, 88), (8, 215), (82, 156), (214, 231), (220, 4), (72, 136), (109, 37), (91, 158), (169, 10), (187, 184), (13, 70), (165, 133), (210, 93), (142, 212), (103, 234), (9, 286), (211, 283), (249, 264), (25, 187), (95, 146), (265, 126), (220, 191), (9, 125), (89, 148), (286, 156), (146, 273), (262, 23), (148, 281), (102, 300), (99, 297), (295, 178), (295, 83), (4, 228), (289, 141), (9, 42), (285, 241), (73, 108), (85, 73), (209, 150), (58, 158), (72, 65), (213, 108), (40, 72), (193, 201), (169, 98), (246, 125), (44, 180), (201, 145), (33, 42), (243, 91), (80, 93), (139, 240), (145, 101), (150, 162), (11, 229), (66, 280), (97, 84), (283, 58), (199, 14), (97, 200), (280, 231), (47, 249), (188, 89), (91, 55), (191, 94), (235, 153), (219, 72), (236, 286), (142, 132), (44, 71), (258, 236), (138, 62), (98, 154), (266, 194), (235, 165), (28, 157), (56, 155), (75, 115), (161, 67), (292, 28), (252, 249), (124, 9), (131, 14), (104, 225), (121, 80), (155, 171), (225, 71), (113, 262), (154, 47), (37, 76), (64, 97), (29, 287), (259, 279), (268, 235), (125, 88), (11, 58), (183, 171), (254, 167), (26, 63), (73, 271), (35, 265), (62, 110), (235, 104), (136, 152), (157, 69), (280, 157), (108, 58), (42, 9), (4, 92), (28, 183), (214, 75), (213, 2), (16, 27), (36, 149), (93, 210), (228, 209), (120, 273), (229, 18), (66, 164), (12, 220), (26, 14), (194, 164), (212, 167), (251, 282), (31, 268), (221, 66), (31, 102), (27, 91), (137, 85), (300, 178), (50, 225), (55, 95), (9, 157), (77, 291), (90, 268), (67, 169), (276, 5), (189, 102), (227, 263), (246, 99), (195, 189), (64, 77), (118, 211), (274, 130), (34, 117), (188, 23), (291, 252), (163, 295), (65, 113), (167, 278), (162, 286), (135, 77), (81, 27)]
optimal_cycle = [0, 60, 6, 250, 215, 102, 199, 275, 298, 241, 231, 77, 203, 184, 187, 288, 63, 56, 216, 189, 236, 32, 73, 274, 134, 273, 291, 38, 278, 237, 197, 51, 183, 248, 295, 224, 101, 152, 107, 149, 154, 170, 166, 219, 138, 48, 54, 2, 12, 126, 79, 277, 97, 42, 146, 281, 68, 234, 263, 112, 5, 175, 176, 16, 280, 41, 20, 202, 246, 98, 69, 208, 247, 271, 238, 106, 162, 33, 179, 201, 266, 23, 148, 141, 165, 256, 9, 193, 78, 282, 265, 186, 223, 28, 260, 19, 10, 222, 89, 279, 74, 3, 169, 92, 108, 255, 157, 242, 53, 245, 87, 195, 36, 181, 259, 267, 59, 124, 254, 121, 127, 90, 96, 39, 50, 91, 299, 34, 210, 253, 57, 21, 153, 93, 75, 228, 229, 136, 81, 55, 218, 18, 251, 225, 235, 113, 15, 140, 128, 109, 155, 292, 205, 71, 258, 151, 264, 46, 145, 103, 58, 105, 135, 257, 213, 233, 272, 94, 22, 27, 173, 283, 226, 95, 204, 52, 178, 144, 76, 286, 196, 82, 249, 133, 188, 159, 99, 211, 284, 209, 147, 191, 30, 8, 158, 111, 100, 194, 185, 116, 125, 43, 212, 221, 244, 35, 115, 192, 65, 167, 110, 290, 143, 180, 7, 252, 171, 122, 276, 177, 17, 220, 24, 123, 14, 207, 62, 240, 217, 227, 139, 182, 142, 66, 293, 84, 37, 117, 132, 239, 270, 164, 285, 86, 214, 70, 163, 49, 45, 1, 26, 104, 119, 296, 29, 294, 297, 174, 44, 172, 129, 47, 25, 198, 13, 118, 72, 161, 230, 261, 114, 206, 137, 131, 289, 160, 31, 156, 287, 190, 120, 61, 150, 262, 130, 83, 88, 67, 11, 168, 80, 40, 269, 268, 243, 64, 4, 85, 200, 232]

graph = get_graph(coordinates)

approximation(graph)
