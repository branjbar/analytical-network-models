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
from modules import basic
from modules import sys_matrix
import numpy as np
from control import dynamics
import math as mt

network_size = 10  # number of robots
SIZE_COEFFICIENT = 100 # for networks smaller than 20
# SIZE_COEFFICIENT = 30  # for networks larger than 20
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
    link_id = len(graph_edges) - 1
    for i in xrange(network_size-1, 0, -1):
        for j in xrange(i-1, -1, -1):
            if graph_edges[link_id]:
                network.add_edge(i, j, weight=graph_edges[link_id])
            link_id -= 1

    # print link_id,
    # positions = NX.shell_layout(network)  # set position
    positions = NX.spring_layout(network)  # set position


def draw():
    global positions



    graph_edges = np.array(X).tolist()
    graph_edges = [x[0] for x in graph_edges]
    node_ss = sys_matrix.get_node_ss(network_size, graph_edges)
    graph_nodes = [node_ss[key] for key in node_ss.keys()]
    node_size = [mt.pow(n, 1.3) * SIZE_COEFFICIENT for n in graph_nodes]  # set nodes size

    # add edges
    link_id = len(graph_edges) - 1
    for i in xrange(network_size-1, 0, -1):
        for j in xrange(i-1, -1, -1):
            if graph_edges[link_id]:
                network.add_edge(i, j, weight=graph_edges[link_id])
            link_id -= 1

    edges_weight, weights = zip(*NX.get_edge_attributes(network, 'weight').items())  # set edges size
    positions = NX.spring_layout(network, pos=positions)

    # draw the graph
    PL.subplot(1,2, 1)
    PL.cla()
    NX.draw(network, positions, node_color='#A0CBE2',
            edgelist=edges_weight, edge_color=weights, width=1,
            edge_cmap=PL.cm.Reds, with_labels=False,
            node_size=node_size)


    PL.axis('image')
    PL.title('network size = %d \n t = %.1f' % (network_size, time/10.0))

    PL.subplot(1, 2, 2)
    PL.cla()
    y = basic.get_distribution(graph_nodes)
    PL.loglog(y.keys(), y.values(), '.r')
    PL.title('Cumulative Degree Distribution')
    PL.xlabel('k')
    PL.ylabel('Pc(k)')


def step():
    global time, network, positions, network_size, fitness, A, X, Flag, positions_2

    if Flag:
        time += 1
        X_old = X
        X = dynamics.step(A, X)
        if max(X - X_old) < .001:
            Flag = False


import pycxsimulator
pycxsimulator.GUI().start(func=[init,draw,step])
