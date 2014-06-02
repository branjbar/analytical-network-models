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
            new_row = row + [0 for j in xrange(index)] + [-2 * (n-2)] + [0 for j in xrange(L - (n-2) * (n-1) / 2 - index - 1)]
            A.append(new_row)

    return A


def get_node_to_link_mapping(N):
    """

    :param n: graph size
    :return: dict that maps each node to all links connected to that
    """

    node_dict = {}
    link_id = 0
    for i in xrange(1,N):
        for j in xrange(0,i):
            node_dict[i] = node_dict.get(i,[]) + [link_id]
            node_dict[j] = node_dict.get(j,[]) + [link_id]
            link_id += 1
    return node_dict


def get_link_ss(A, x_0=1):
    """

    :param i: link id
    :param A: complete system matrix
    :return: steady state value
    """
    # print "link_", i

    link_ss_dict = {0: x_0}
    N = len(A)
    for i in xrange(1, N):
        ss = 0
        for index, link_weight in enumerate(A[i]):
            if link_weight == 1:
                ss += link_ss_dict[index]
            if link_weight < 0:
                ss = -1.0 * ss / link_weight
                break
        link_ss_dict[i] = ss
    return link_ss_dict






