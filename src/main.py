__author__ = 'B.Ranjbarsahraei'

import matplotlib
matplotlib.use('TKAgg')

from modules import sys_matrix
from modules import basic
from modules import drawer

def main():

    N = 100
    A = sys_matrix.get_graph_dynamic(N)

    # basic.print_matrix_print(A)
    node_to_link = sys_matrix.get_node_to_link_mapping(N)
    links_ss = sys_matrix.get_link_ss(A)
    nodes_ss = {}
    for key in node_to_link.keys():
        link_ids = node_to_link[key]
        ss = 0
        for link_id in link_ids:
            ss += links_ss[link_id]
        nodes_ss[key] = ss

    y1 = [links_ss[key] for key in links_ss.keys()]
    y2 = [nodes_ss[key] for key in nodes_ss.keys()]
    drawer.draw_y(y2)

if __name__ == "__main__":
    main()
