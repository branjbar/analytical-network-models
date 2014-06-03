__author__ = 'B.Ranjbarsahraei'

from modules import basic
import math
def get_node_ss(i=0, x0=1):
    """

    :param i: node id
    :return: final steady state value for edges of node i
    """

    if i == 0:
        return x0

    for j in xrange(i):
        return j


def get_ss(n=10, x0=1):
    """

    :param n: number of nodes
    :return: list of steady-state values for all nodes
    """
    edges_ss = [[0 for i in range(n+1)] for j in range(n+1)]
    edges_ss[1][0] = x0
    edges_ss[0][1] = x0

    for i in xrange(2, n+1):
        for j in xrange(1, i):
            deg_j = 0
            for k in xrange(0, i):
                deg_j += edges_ss[k][j]

            edges_ss[i][j] = deg_j
            edges_ss[j][i] = deg_j

        sum_deg = sum(edges_ss[i])

        for j in xrange(1, i):
            edges_ss[i][j] /= float(sum_deg)
            edges_ss[j][i] /= float(sum_deg)


    # basic.print_matrix_print(edges_ss)
    A = edges_ss
    A = [x[1:] for x in A[1:]]
    return A

if __name__ == "__main__":


    basic.print_matrix_print(get_ss())



