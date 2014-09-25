__author__ = 'Bijan'


class Game:

    benefit = 4
    cost = 1
    delta_t = .1
    agents = []
    neighbors = {}

    def __init__(self, agents=[], neighbors={}):
        self.agents = agents
        self.neighbors = neighbors

    def update_fitness(self, agent_i):
        """
        update fitness of ith agent based on her neighbors.
        """
        self.agents[agent_i].fitness = 0
        for agent_j in self.neighbors[agent_i]:
            self.agents[agent_i].fitness += self.benefit * self.agents[agent_j].x - self.cost * self.agents[agent_i].x

    def update_fitness_all(self):
        """
        update fitness of ith agent based on her neighbors.
        """
        for agent in self.agents:
            self.update_fitness(agent.id)


    def update_x(self, agent_i):
        """
        update fitness of ith agent based on her neighbors.
        """
        self.agents[agent_i].fitness = 0
        for agent_j in self.neighbors[agent_i]:
            self.agents[agent_i].fitness += self.benefit * self.agents[agent_j].x - self.cost * self.agents[agent_i].x

    def update_x_all(self):
        """
        update fitness of ith agent based on her neighbors.
        """
        for agent in self.agents:
            self.update_fitness(agent.id)