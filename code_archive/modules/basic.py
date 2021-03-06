__author__ = 'B.Ranjbarsahraei'

def pretty_print(d, indent=0):
    """
prints a pretty tree from a stored in a mixed dictionary and list
"""
    if indent < 100:
        if isinstance(d, dict):
            for key, value in d.iteritems():
                print '\t' * indent + str(key)
                if isinstance(value, dict) or isinstance(value, list):
                    pretty_print(value, indent+1)
                else:
                    print '\t' * (indent+1) + str(value)

        if d and isinstance(d, list):
            for key, item in enumerate(d):
                print '\t' * indent + str(key)
                if isinstance(item, dict) or isinstance(item, list):
                    pretty_print(item, indent+1)
                else:
                    print '\t' * (indent+1) + str(item)


def print_matrix_print(M, indent=1):
    """
    prints a pretty tree from a stored in a mixed dictionary and list
    """
    print '['
    for row in M:
        print '|', '\t' * indent,
        for item in row:
            print "%.3f"%item, '\t' * indent,
        print "|\n",
    print ']'

def get_distribution(x, b=1000):
    """
    x: list of non-negative numbers
    b: bin size
    return: (k,Pk) where Pk shows the probability of a number between k and k + b
    """

    Pk = {}
    m = max(x) / float(b)
    for k in xrange(b):
        Pk[k * m] = sum([i >= k * m for i in x]) / float(len(x))

    return Pk


def matrix_product(X,Y):
    """
    x: M x L list
    y: L x N list
    result: matrix produce of x*y
    """
    M = len(X)
    N = len(Y[0])

    Lx = len(X[0])
    Ly = len(Y)
    if Lx != Ly:
        print "Err: matrix dimensions miss mach! a %dx%d matrix times %dx%d" % (M, Lx, Ly, N)
        return 0

    result = [[0 for j in xrange(N)] for j in xrange(M)]

    # iterate through rows of X
    for i in xrange(M):
       # iterate through columns of Y
       for j in xrange(N):
           # iterate through rows of Y
           for k in xrange(Ly):
               result[i][j] += X[i][k] * Y[k][j]
    return result
if __name__ == "__main__":
    pass
