__author__ = 'B.Ranjbarsahraei'

import matplotlib
matplotlib.use('TKAgg')

from modules import sys_matrix_new
from modules import sys_matrix

from modules import drawer


def main():

    N = 100
    A_0 = sys_matrix.get_graph_dynamic(N)
    A_new = sys_matrix_new.get_graph_dynamic(N)

    # basic.print_matrix_print(A)
    node_to_link = sys_matrix.get_node_to_link_mapping(N)
    links_ss_0 = sys_matrix.get_link_ss(A_0)
    nodes_ss_0 = {}
    for key in node_to_link.keys():
        link_ids = node_to_link[key]
        ss = 0
        for link_id in link_ids:
            ss += links_ss_0[link_id]
        nodes_ss_0[key] = ss

    links_ss_new = sys_matrix.get_link_ss(A_new)
    nodes_ss_new = {}
    for key in node_to_link.keys():
        link_ids = node_to_link[key]
        ss = 0
        for link_id in link_ids:
            ss += links_ss_new[link_id]
        nodes_ss_new[key] = ss


    Edges = [links_ss_0[key] for key in links_ss_0.keys()]
    Nodes_0 = [nodes_ss_0[key] for key in nodes_ss_0.keys()]
    Nodes_new = [nodes_ss_new[key] for key in nodes_ss_new.keys()]

    drawer.draw_deg_dist(Nodes_0, Nodes_new)

    # drawer.draw_graph(Nodes, Edges)

if __name__ == "__main__":
    main()
