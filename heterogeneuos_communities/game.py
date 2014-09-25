import random

__author__ = 'Bijan'


class Game:

    benefit = .4
    cost = .1
    delta_t = .1
    time = None
    agents = []

    neighbors = {}  # TODO: Later we should integrate game with networkx.

    def __init__(self, agents=[], neighbors={}):
        self.agents = agents
        self.neighbors = neighbors
        self.time = 0
        self.update_fitness_all()

    def update_fitness(self, agent_i):
        """
        returns the new fitness of ith agent based on her neighbors
        """
        self.agents[agent_i].fitness = 0
        fitness_i = 0
        for agent_j in self.neighbors[agent_i]:
            fitness_i += self.benefit * self.agents[agent_j].x - self.cost * self.agents[agent_i].x

        return fitness_i

    def update_fitness_all(self):
        """
        updates fitness of all agents
        """
        for agent in self.agents:
            agent.fitness = self.update_fitness(agent.id)

    def update_x(self, agent_i):
        """
        returns the different of x with it's neighbors considering the fitness differences
        """
        delta_x_i = 0
        if self.agents[agent_i].type == "GRAY":  # imitation-based dynamic
            for agent_j in self.neighbors[agent_i]:
                delta_x_i += (self.agents[agent_j].x - self.agents[agent_i].x) * \
                             (self.agents[agent_j].fitness - self.agents[agent_i].fitness)

        if self.agents[agent_i].type == "RANDOM":  # Crazy dynamics
            delta_x_i = (.5 / self.delta_t) * (.5 - random.random())


        return delta_x_i

    def update_x_all(self):
        """
        updates all the states
        """
        self.time += self.delta_t
        agent_x = []
        for agent in self.agents:
            agent_x.append(self.update_x(agent.id))

        for index, agent in enumerate(self.agents):
            agent.x += agent_x[index] * self.delta_t
            agent.history.append({'time': self.time,
                                  'x': agent.x,
                                  'fitness': agent.fitness,
                                  })

    def print_agents(self):
        for agent in self.agents:
            print agent, '  --------- ',
        print


