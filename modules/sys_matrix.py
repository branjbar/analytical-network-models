__author__ = 'B.Ranjbarsahraei'


def get_node_dynamic(i=1, delta=1):
    """

    :param i: node number
    :return: a set of rows corresponding to edges of node i


    n --e--> n:
    ----------
    1 --0--> 0
    2 --1--> 1
    3 --2--> 1, 3 --3--> 2
    4 --4--> 1, 4 --5--> 2, 4 --6--> 3
    5 --7--> 1, 5 --8--> 2, 5 --9--> 3, 5 --10--> 4

    """

    if i == 1:
        return [[0]]  # edge zero corresponding to node one, does not have any dynamic

    if i == 2:
        return [[1]] # edge one corresponding to node two, have a simple dynamic

    if i > 2:
        a_i = get_node_dynamic(i-1, delta)
        # following few lines are the confusing part to construct the A matrix,
        # you can simply construct the matrix on a piece of paper a few times in order to find the pattern
        for index, row in enumerate(a_i):
            M = [0 for j in xrange(index)] + [delta] + [0 for j in xrange(i-index-3)]
            a_i[index] += M

        a_i.append([0 for j in xrange(((i-2) * (i-3) / 2)+1)] + [delta for j in xrange(i-2)])

        return a_i


def get_graph_dynamic(N=6, delta=1):
    """
    :param N: number of nodes (i.e., size of graph)
    :return: system matrix
    """

    L = N * (N-1) / 2  # number of edges
    A = []
    for n in xrange(1, N+1):
        for index, row in enumerate(get_node_dynamic(n, delta)):
            new_row = row + [0 for j in xrange(index)] + [- (2 * n - 3)] + [0 for j in xrange(L - (n-2) * (n-1) / 2 - index - 1)]
            A.append(new_row)
    A[0][1] = 0
    return A


def get_node_to_link_mapping(N):
    """

    :param n: graph size
    :return: dict that maps each node to all links connected to that
    """

    node_dict = {}
    link_id = 1
    for i in xrange(1, N+1):
        for j in xrange(1, i):
            node_dict[i] = node_dict.get(i, []) + [link_id]
            node_dict[j] = node_dict.get(j, []) + [link_id]
            link_id += 1
    # print node_dict
    return node_dict


def get_link_ss(A, x_0=1):
    """

    :param A: complete system matrix
    :return: steady state value for all links

    assuming delta=1, analytically we get the following results:
    n1) e0 = 1
    n2) e1 --> 1
    n3) e2 --> 2/3, e3 --> 1/3
    n4) e4 --> (4*2)/(5*3), e5 --> (4*1)/(5*3), e6 --> (3*1)/(5*3)
    n5) e7 --> (6*4*2)/(7*5*3), e8 --> (6*4*1)/(7*5*3), e9 --> (6*3*1)/(7*5*3), , e10 --> (5*3*1)/(7*5*3)

    """
    # print "link_", i

    link_ss_dict = {0: x_0}
    N = len(A)
    for i in xrange(1, N):
        ss = 0
        for index, link_weight in enumerate(A[i]):
            if link_weight > 0:
                ss += link_weight * link_ss_dict[index]
            if link_weight < 0:
                ss = -1.0 * ss / link_weight
                break
        link_ss_dict[i] = ss

    return link_ss_dict


def get_node_ss(n, links_ss):
    """

    :param i: link id
    :param a: complete system matrix
    :return: steady state value for all nodes
    """

    node_to_link = get_node_to_link_mapping(n)

    nodes_ss = {}
    for key in node_to_link.keys():
        link_ids = node_to_link[key]
        ss = 0
        for link_id in link_ids:
            ss += links_ss[link_id]
        nodes_ss[key] = ss

    return nodes_ss




if __name__ == "__main__":
    print get_node_dynamic(3)



