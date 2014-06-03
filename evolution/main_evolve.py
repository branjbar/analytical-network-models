# Simple Network Dynamics simulator in Python
#
# *** Network Growth ***
#
# Copyright 2011-2012 Hiroki Sayama
# sayama@binghamton.edu

import matplotlib
matplotlib.use('TkAgg')

import pylab as PL
import networkx as NX
import math as MT
from modules import sys_matrix
import numpy as np
from control import dynamics

network_size = 50  # number of robots
A = sys_matrix.get_graph_dynamic(network_size, 1)



def init():
    global time, network, positions, network_size, X, A, Flag

    Flag = True

    time = 0

    # links_ss = sys_matrix.get_link_ss(A)  # the steady state value for each link

    # graph_edges = [links_ss[key] for key in links_ss.keys()]

    X = np.matrix([[1.0]] + [[0.00001] for j in xrange(len(A)-1)])
    A = np.matrix(A)

    network = NX.Graph()

    graph_edges = np.array(X).tolist()
    graph_edges = [x[0] for x in graph_edges]

    # add edges
    link_id = 0
    for i in xrange(1,network_size):
        for j in xrange(0,i):
            if graph_edges[link_id]:
                network.add_edge(i, j, weight=graph_edges[link_id])
            link_id += 1

    # positions = NX.shell_layout(network)  # set position
    positions = NX.spring_layout(network)  # set position
def draw():
    global positions
    PL.cla()



    graph_edges = np.array(X).tolist()
    graph_edges = [x[0] for x in graph_edges]
    node_ss = sys_matrix.get_node_ss(network_size, graph_edges)
    graph_nodes = [node_ss[key] for key in node_ss.keys()]
    node_size = [n * 100 for n in graph_nodes]  # set nodes size

    # add edges
    link_id = 0
    for i in xrange(1,network_size):
        for j in xrange(0,i):
            if graph_edges[link_id]:
                network.add_edge(i, j, weight=graph_edges[link_id])
            link_id += 1

    edges_weight, weights = zip(*NX.get_edge_attributes(network, 'weight').items())  # set edges size


    # draw the graph
    NX.draw(network, positions, node_color='#A0CBE2',
            edgelist=edges_weight, edge_color=weights, width=1,
            edge_cmap=PL.cm.Reds, with_labels=False,
            node_size=node_size)

    PL.axis('image')
    PL.title('t = ' + str(time))


def step():
    global time, network, positions, network_size, fitness, A, X, Flag, positions_2

    if Flag:
        time += 1
        X_old = X
        X = dynamics.step(A, X)
        if sum(X - X_old) > .05:
            positions_2 = NX.spring_layout(network)  # set position
            positions = [(positions[i] + .01 * positions_2[i] )/ 1.01 for i in xrange(len(positions))]
        else:
            Flag = False
    else:
        positions = [(positions[i] + .01 * positions_2[i] )/ 1.01 for i in xrange(len(positions))]

import pycxsimulator
pycxsimulator.GUI().start(func=[init,draw,step])
