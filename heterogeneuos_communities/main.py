import matplotlib
matplotlib.use('TkAgg')

import pylab as PL
from agent import Agent
from game import Game
import math

def draw(y):
    PL.cla()
    PL.figure(1)
    PL.plot(y[0], '.-k', y[1], 'o-b', y[2], '-r')
    # PL.title('Evolution of Behaviors')
    PL.xlabel('time')
    PL.ylabel('behavior')
    PL.legend(["GRAY_1", "GRAY_2", "RANDOM"])
    PL.ylim([-5, 5])
    PL.show()


for i in xrange(10000):
    sim_time = 100
    neighbors = {0: [1], 1: [0, 2], 2: [1]}
    agents = [Agent(0, "GRAY", 0), Agent(1, "GRAY", 1), Agent(2, "RANDOM", .5)]  # list of agent
    # agents = [Agent(0, "GRAY", 0), Agent(1, "GRAY", 1)]  # list of agent
    game = Game(agents, neighbors)
    game.update_fitness_all()
    # game.print_agents()
    for i in xrange(sim_time):
        game.update_x_all()
        game.update_fitness_all()
        # game.print_agents()

    agent_x_list = []
    for agent in game.agents:
        # print ['%+2.2f' % x['x'] for x in agent.history]
        agent_x_list.append([x['x'] for x in agent.history])
    # print game.agents[0].history
    # print game.agents[1].history
    # if agent_x_list[0][-1] > 0:
    draw(agent_x_list)



