__author__ = 'Bijan'

from modules import basic
import numpy as np

def step(A, X, B=0, U=0, dt=.01):
    """

    """

    Delta_X = np.dot(A,X)
    if B and U:
        Delta_X += np.dot(B, U)

    X_new = X + Delta_X * dt

    return X_new


def evolve_net(A):
    """
    a: system matrix
    """

    X = np.matrix([[1.0]] + [[0] for j in xrange(len(A)-1)])
    A = np.matrix(A)

    for i in xrange(10):
        X = step(A, X)

    print X