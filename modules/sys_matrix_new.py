__author__ = 'B.Ranjbarsahraei'


def get_node_dynamic(i=1):
    """

    :param i: node number
    :return: a set of rows corresponding to edges of node i
    """
    if i == 1:
        print "Err: node 1 doesn't have any corresponding row!"
        return []

    if i == 2:
        return [[]]

    if i == 3:
        return [[1],
                [1]]

    if i > 3:
        a_i_1 = get_node_dynamic(i-1)
        for index, row in enumerate(a_i_1):
            M = [0 for j in xrange(index)] + [1] + [0 for j in xrange(i-index-3)]
            a_i_1[index] += M

        a_i_1.append([0 for j in xrange(((i-2) * (i-3) / 2))] + [1 for j in xrange(i-2)])

        return a_i_1


def get_graph_dynamic(N=6):
    """
    :param N: number of nodes (i.e., size of graph)
    :return: system matrix
    """

    L = N * (N-1) / 2  # number of edges
    A = []
    for n in xrange(2, N+1):
        for index, row in enumerate(get_node_dynamic(n)):
            new_row = row + [0 for j in xrange(index)] + [-4 * (n-2)] \
                          + [0 for j in xrange(L - (n-2) * (n-1) / 2 - index - 1)]
            A.append(new_row)

    return A





