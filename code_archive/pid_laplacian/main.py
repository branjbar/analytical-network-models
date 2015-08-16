__author__ = 'bijan'

import matplotlib
matplotlib.use('TKAgg')



from modules import drawer
import networkx
import random
import pickle

k_p = -1  # proportional coefficient
k_i = -10000
k_d = 0
dt = 0.01
net_size=40

for k_d in [i * -.1 for i in xrange(5)]:
    for k_i in [i * -1000 for i in xrange(5)]:
        for k_p in [i * -1 for i in xrange(5)]:
            graph = networkx.barbell_graph(net_size/2, 0)
            trajectory = []
            u = {}
            e = {}
            e_i = {}
            e_d = {}
            for n in graph:
                graph.node[n]['x'] = random.random() * n / 20.0
                trajectory.append([graph.node[n]['x']])
                u[n] = []
                e[n] = []
                e_i[n] = []
                e_d[n] = []
            # pickle.dump([graph, trajectory], open("graph.dat","wa"))

            [graph, trajectory] = pickle.load(open("graph.dat","r"))

            for time in xrange(1000):
                for n in graph:
                    d_sum = 0
                    for nbr in graph.neighbors(n):
                        d_sum += graph.node[nbr]['x']

                    e[n].append(graph.node[n]['x'] - 1.0 * d_sum / graph.degree(n))
                    if time > 0:
                        e_i[n].append((e_i[n][-1] + time * e[n][-1] * dt) / float(time))
                        e_d[n].append((e[n][-1] - e[n][-2]) / dt)

                    else:  # first element
                        e_i[n] = [0]
                        e_d[n] = [0]
                    # print e[n], e_i[n], e_d[n]
                    u[n].append(k_p * e[n][-1] + k_i * e_i[n][-1] + k_d * e_d[n][-1])
                    graph.node[n]['x'] += u[n][-1] * dt

                    trajectory[n].append(graph.node[n]['x'])
            # print e_d
            # drawer.draw_y(states)
            drawer.draw_trajectory(trajectory, file_name="laplacian_N=%d,kp=%.2f,ki=%.2f,kd%.2f.png" % (net_size,k_p,k_i,k_d))
            # drawer.draw_trajectory(trajectory)



# drawer.visualize_graph(graph)


