__author__ = 'B.Ranjbarsahraei'

import matplotlib
matplotlib.use('TKAgg')

import pylab as PL
import math
import basic
import networkx as nx

def draw_demo():
    """
    draws a sample sinus curve
    """
    y = []
    x = [i/50.0 for i in xrange(500)]
    for index, x_i in enumerate(x):
        print index, x_i
        y.append(math.sin(x_i))

    PL.cla()
    PL.plot(x,y)
    PL.title('Demo Drawing')
    PL.xlabel('x axis')
    PL.ylabel('y axis')
    PL.show()


def draw_y(y):
    """
    plots the graph y
    y: dict in form of {x0:y0, x1:y1, x2:y2, ..., xn:yn}
    """
    PL.cla()
    PL.plot(y.keys(), y.values(), '-')
    PL.xlabel('x')
    PL.ylabel('y')
    PL.ylim([0,1])
    PL.show()

def draw_trajectory(trajectory, file_name=None):
    """
    plots the graph y
    y: dict in form of {x0:y0, x1:y1, x2:y2, ..., xn:yn}
    """
    PL.cla()
    for y in trajectory:
        PL.plot(y, '-')
    PL.xlabel('x')
    PL.ylabel('y')
    PL.ylim([0,1])
    if not file_name:
        PL.show()
    else:
        PL.savefig("../data/figs/" + file_name ) # save as png




def draw_deg_dist(Pk, Pk2=None):
    """
    Pk: the distribution for degree k
    """
    PL.cla()
    y = basic.get_distribution(Pk)
    PL.loglog(y.keys(), y.values(), '.r')
    if Pk2:
        PL.hold(True)
        y = basic.get_distribution(Pk2)
        PL.loglog(y.keys(), y.values(), '.k')

    PL.loglog([1,10],[1,.01],'r')
    PL.loglog([.01,1],[1,0.01],'r')
    PL.title('Degree Distribution')
    PL.xlabel('k')
    PL.ylabel('Pc(k)')
    PL.show()


def draw_graph(nodes_degree, edges_weight):
    """
    draws and also exports a graph according to the nodes size and edges weight tzhat are provided
    nodes_degree: list of nodes degree
    edges_weight: list of edges degree
    """

    N = len(nodes_degree)  # get graph size
    G = nx.Graph()  # define an empty graph

    # add edges
    link_id = 1
    for i in xrange(1,N):
        for j in xrange(0,i):
            if edges_weight[link_id] > .01:
                G.add_edge(i, j, weight=edges_weight[link_id])
            link_id += 1

    node_size = [n * 100 for n in nodes_degree]  # set nodes size
    edges_weight, weights = zip(*nx.get_edge_attributes(G,'weight').items())  # set edges size
    pos = nx.spring_layout(G)  # set position
    # draw the graph
    nx.draw(G, pos, node_color='#A0CBE2',
            edgelist=edges_weight, edge_color=weights, width=4,
            edge_cmap=PL.cm.Reds, with_labels=True,
            node_size=node_size)

    PL.savefig("../data/graphs/text_graph_%d.png" % N) # save as png
    nx.write_gml(G,"../data/graphs/test_graph_%d.gml" % N)


    PL.show() # display


def visualize_graph(graph):
    """
    quickly visualizes a graph
    :return:
    """
    nx.draw(graph)
    PL.show()
