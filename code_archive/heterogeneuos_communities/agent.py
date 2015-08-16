__author__ = 'Bijan'


class Agent:
    """
    a general class for all our agents
    """
    id = None  # agent id = 0, 1, 2, ...
    type = None  # agent type in {'GRAY', 'SMART'}
    x = None  # agent behavior in [-infinity, +infinity]
    fitness = None  # agent fitness in [-infinity, +infinity]
    history = []  # agent history is a dictionary of dictionary in form of [{'x':x, 'fitness':fitness, 'time':time}]

    def __init__(self, agent_id, agent_type=None, x=None, fitness=None):
        self.id = agent_id
        self.type = agent_type
        self.x = x
        self.fitness = fitness
        self.history = [{'time': 0, 'x':self.x}]

    def __str__(self):
        return 'A_%s) %s: x=%s, F=%s' % (self.id, self.type, self.x, self.fitness)

    def get_id(self):
        return self.id

