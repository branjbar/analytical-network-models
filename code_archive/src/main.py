__author__ = 'B.Ranjbarsahraei'

import matplotlib
matplotlib.use('TKAgg')

from modules import sys_matrix
from modules import basic
from modules import drawer
from control import dynamics

def main():

    n = 30  # number of nodes
    A = sys_matrix.get_graph_dynamic(n, 1)  # the system matrix
    # basic.print_matrix_print(A)
    links_ss = sys_matrix.get_link_ss(A)  # the steady state value for each link
    node_ss = sys_matrix.get_node_ss(n, A)

    graph_edges = [links_ss[key] for key in links_ss.keys()]
    graph_nodes = [node_ss[key] for key in node_ss.keys()]

    dynamics.evolve_net(A)

    # drawer.draw_deg_dist(graph_nodes)
    # drawer.draw_graph(graph_nodes, graph_edges)

if __name__ == "__main__":
    main()
