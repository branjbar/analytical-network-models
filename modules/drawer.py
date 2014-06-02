__author__ = 'B.Ranjbarsahraei'

import matplotlib
matplotlib.use('TKAgg')

import pylab as PL
import math


def draw_demo():
    """
    draws a sample sinus curve
    """
    y = []
    x = [i/50.0 for i in xrange(500)]
    for index, x_i in enumerate(x):
        print index, x_i
        y.append(math.sin(x_i))

    PL.cla()
    PL.plot(x,y)
    PL.title('Demo Drawing')
    PL.xlabel('x axis')
    PL.ylabel('y axis')
    PL.show()


def draw_y(y):
    PL.cla()
    PL.plot(y)
    PL.title('Demo Drawing')
    PL.xlabel('x axis')
    PL.ylabel('y axis')
    PL.show()