__author__ = 'B.Ranjbarsahraei'

import matplotlib
matplotlib.use('TKAgg')

from modules import sys_matrix_new
from modules import sys_matrix
from modules import sys_matrix_numerical
from modules import basic

from modules import drawer


def main():

    N = 20
    A_0 = sys_matrix.get_graph_dynamic(N)

    node_to_link = sys_matrix.get_node_to_link_mapping(N)
    links_ss_0 = sys_matrix.get_link_ss(A_0)
    nodes_ss_0 = {}
    for key in node_to_link.keys():
        link_ids = node_to_link[key]
        ss = 0
        for link_id in link_ids:
            ss += links_ss_0[link_id]
        nodes_ss_0[key] = ss

    links_ss_new = sys_matrix_numerical.get_ss(N)
    nodes_ss_new = {}
    for i in xrange(N):
        nodes_ss_new[i] = sum(links_ss_new[i])



    Edges = [links_ss_0[key] for key in links_ss_0.keys()]
    Nodes_0 = [nodes_ss_0[key] for key in nodes_ss_0.keys()]

    Nodes_new = [nodes_ss_new[key] for key in nodes_ss_new.keys()]
    print Nodes_new
    print Nodes_0
    drawer.draw_deg_dist(Nodes_new, Nodes_0)

    drawer.draw_graph(Nodes_0, Edges)

if __name__ == "__main__":
    main()
