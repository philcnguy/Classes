#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 15 09:12:40 2020

@authors: sonia, parth, neilabh
"""



from gridWorld import *

from nextState import nextState
from collisionfreeTransitions import *
from smallGrid import smallGrid 
from mediumGrid import mediumGrid
from testGrid import testGrid
from costFunction import getCost, getCostBridge
import numpy as np
import copy



###############
""" This part calculates the stage costs associated with each grid"""

def compute_stage_cost(cost, gridname):
    if gridname=='small':
        n, m, O, START, WINSTATE, LOSESTATE = smallGrid()
    elif gridname=='medium':
        n, m, O, START, DISTANTEXIT, CLOSEEXIT, LOSESTATES = mediumGrid()
    elif gridname=='test':
        n, m, O, START, WINSTATE, DISTANTEXIT, LOSESTATE, LOSESTATES = testGrid()
    else:
        raise NameError("Unknown grid")
    # Compute all stage costs
    stage_cost = 99999*np.ones((n, m))
    for i in range(n):
        for j in range(m):
            xprime = [i,j] #Cost functions expect an array.
            if isObstacle(xprime,O) == False:
                if cost == 'cost':
                    stage_cost[i,j] = getCost(xprime,gridname)
                elif cost == 'bridge':
                    stage_cost[i,j] = getCostBridge(xprime,gridname)
                else:
                    print ('Incorrect cost string.')
            else:
                stage_cost[i,j] = np.nan
    return stage_cost

###############

""" Here is where you program the iterations """


"""
Implement your value iteration algorithm
"""


def valueIteration(gamma,cost,eta,gridname):

    """
    (Offline) Policy iteration with a discount factor gamma and 
    pre-defined cost functions. 
    Output:
    values: Numpy array of (n,m) dimensions
    policy: Numpy array of (n,m) dimensions
    """

    # This part loads parameters, environment, and states for the
    # iterations according to the environment

    if gridname=='small':
        n, m, O, START, WINSTATE, LOSESTATE = smallGrid()
    elif gridname=='medium':
        n, m, O, START, DISTANTEXIT, CLOSEEXIT, LOSESTATES = mediumGrid()
    elif gridname=='test':
        n, m, O, START, WINSTATE, DISTANTEXIT, LOSESTATE, LOSESTATES = testGrid()
    else:
        raise NameError("Unknown grid")

    # Initialize values, policies, and stage costs as matrices of
    # appropriate dimensions here
    
    values = np.zeros((n,m))
    policy = [[[0,0], [0,0], [0,0], [0,0], [0,0]],
              [[0,0], [0,0], [0,0], [0,0], [0,0]],
              [[0,0], [0,0], [0,0], [0,0], [0,0]],
              [[0,0], [0,0], [0,0], [0,0], [0,0]],
              [[0,0], [0,0], [0,0], [0,0], [0,0]],
              [[0,0], [0,0], [0,0], [0,0], [0,0]]]
    stage_costs = cost

    # Implement policy iteration here with a minimization goal. Employ
    # synchronous updates for policy evaluation and calculate the
    # values of the policy with an error <= 1e-4
    
    error = 1e-3
    iterations = 0
    
    while True:
        while True:
            delta = 0
            for i in range(1, n-1):
                for j in range(1, m-1):
                    if [i, j] != WINSTATE and [i, j] != LOSESTATE:
                        v = values[i, j]
                        values[i, j] = stage_costs[i, j] + gamma * values[i, j]
                        delta = max(delta, abs(v - values[i, j]))
            if delta < error:
                break
            
        policy_stable = True
        for i in range(1, n-1):
            for j in range(1, m-1):
                if (i, j) != WINSTATE and (i, j) != LOSESTATE:
                    old_action = policy[i][j]
                    max_val = float('-inf')
                    max_action = None
                    for action in [[0, 1], [0, -1], [-1, 0], [0, 1]]:
                        if action != old_action:
                            new_val = stage_costs[i + action[0], j + action[1]] + gamma * values[i + action[0], j + action[1]]
                            if new_val > max_val:
                                max_val = new_val
                                max_action = action
                    policy[i][j] = max_action
                    if max_action != old_action:
                        policy_stable = False
        
        iterations += 1
        
        if policy_stable:
            break
    
    return values, policy, iterations

"""
Implement your policy iteration algorithm
"""

def policyIteration(gamma,cost,eta,gridname):
    """
    (Offline) Policy iteration with a discount factor gamma and 
    pre-defined cost functions. 
    Output:
    values: Numpy array of (n,m) dimensions
    policy: Numpy array of (n,m) dimensions
    """

    # This part loads parameters, environment, and states for the
    # iterations according to the environment

    if gridname=='small':
        n, m, O, START, WINSTATE, LOSESTATE = smallGrid()
    elif gridname=='medium':
        n, m, O, START, DISTANTEXIT, CLOSEEXIT, LOSESTATES = mediumGrid()
    elif gridname=='test':
        n, m, O, START, WINSTATE, DISTANTEXIT, LOSESTATE, LOSESTATES = testGrid()
    else:
        raise NameError("Unknown grid")

    # Initialize values, policies, and stage costs as matrices of
    # appropriate dimensions here
    
    values = np.zeros((n,m))
    policy = [[[0,0], [0,0], [0,0], [0,0], [0,0]],
              [[0,0], [0,0], [0,0], [0,0], [0,0]],
              [[0,0], [0,0], [0,0], [0,0], [0,0]],
              [[0,0], [0,0], [0,0], [0,0], [0,0]],
              [[0,0], [0,0], [0,0], [0,0], [0,0]],
              [[0,0], [0,0], [0,0], [0,0], [0,0]]]
    stage_costs = cost

    # Implement policy iteration here with a minimization goal. Employ
    # synchronous updates for policy evaluation and calculate the
    # values of the policy with an error <= 1e-4
    
    error = 1e-3
    iterations = 0
    
    while True:
        while True:
            delta = 0
            for i in range(1, n-1):
                for j in range(1, m-1):
                    if [i, j] != WINSTATE and [i, j] != LOSESTATE:
                        v = values[i, j]
                        values[i, j] = stage_costs[i, j] + gamma * values[i, j]
                        delta = max(delta, abs(v - values[i, j]))
            if delta < error:
                break
            
        policy_stable = True
        for i in range(1, n-1):
            for j in range(1, m-1):
                if (i, j) != WINSTATE and (i, j) != LOSESTATE:
                    old_action = policy[i][j]
                    max_val = float('-inf')
                    max_action = None
                    for action in [[0, 1], [0, -1], [-1, 0], [0, 1]]:
                        if action != old_action:
                            new_val = stage_costs[i + action[0], j + action[1]] + gamma * values[i + action[0], j + action[1]]
                            if new_val > max_val:
                                max_val = new_val
                                max_action = action
                    policy[i][j] = max_action
                    if max_action != old_action:
                        policy_stable = False
        
        iterations += 1
        
        if policy_stable:
            break
    
    return values, policy, iterations
    

def optimalValues(question):
    """
    Please input your values of gamma and eta
    for each assignment problem here.
    """
    if question=='a':
        gamma=0.9
        eta=0.2
        return gamma, eta
    elif question=='b':
        gamma=0.9
        eta=0.2
        return gamma, eta
    elif question=='c':
        gamma=0.9
        eta=0.2
        return gamma, eta
    elif question=='d1':
        gamma=0.9
        eta=0.2
        return gamma, eta
    elif question=='d2':
        gamma=0.9
        eta=0.2
        return gamma, eta
    elif question=='d3':
        gamma=0.9
        eta=0.2
        return gamma, eta
    elif question=='d4':
        gamma=0.9
        eta=0.2
        return gamma, eta
    else: 
        pass
    return 0
    
def showPath(xI,xG,path,n,m,O):
    gridpath = makePath(xI,xG,path,n,m,O)
    fig, ax = plt.subplots(1, 1) # make a figure + axes
    ax.imshow(gridpath) # Plot it
    ax.invert_yaxis() # Needed so that bottom left is (0,0)
    
    
# Function to actually plot the cost-to-gos
def plotValues(values,xI,xG,n,m,O):
    gridvalues = makeValues(values,xI,xG,n,m,O)
    fig, ax = plt.subplots() # make a figure + axes
    ax.imshow(gridvalues) # Plot it
    ax.invert_yaxis() # Needed so that bottom left is (0,0)


def showValues(n,m,values,O):
    string = '------'
    for i in range(0, n):
        string = string + '-----'
    for j in range(0, m):
        print(string)
        out = '| '
        for i in range(0, n):            
            jind = m-j-1 # Need to reverse index so bottom-left is (0,0)
            if isObstacle((i,jind),O):
                out += 'Obs' + ' | '
            else:
                out += str(values[i,jind]) + ' | '
        print(out)
    print(string)    


    
def showPolicy(n,m,policy,O):
    uSet2 = ["-->","^", "<--", "v"]
    showValues(n,m,np.array([[uSet2[a] for a in row] for row in policy], O))
    

if __name__ == '__main__':
    gridname='small'
    # Use small and medium grid for your code submission
    # cost types: {'cost', 'bridge'}
    if gridname=='small':
        n, m, O, START, WINSTATE, LOSESTATE = smallGrid()
    elif gridname=='medium':
        n, m, O, START, DISTANTEXIT, CLOSEEXIT, LOSESTATES = mediumGrid()
    # elif gridname=='test':
    #     n, m, O, START, WINSTATE, DISTANTEXIT, LOSESTATE, LOSESTATES = testGrid()
    else:
        raise NameError("Unknown grid")
    
    # values, policy = valueIteration()
    # values, policy = policyIteration()
    """
    # Case 1:
    """
    gridname = 'medium'
    values, policy, iterations = policyIteration(0.9, compute_stage_cost('cost', 'small'), 0.2, 'small') 
    """
    #Case 2
    """
    """
    # Case 3
    """
    """
    # Case 4
    """
    
    # Sample use of plotValues from gridWorld
    values = np.zeros((n,m))
    # Loop through values to just assign some dummy/arbitrary data
    for i in range(n):
        for j in range(m):
            if not(isObstacle((i,j),O)):
                values[i][j] = (n+2*m-2) - (i + 2*j)
    # This will print those numeric values as console text
    showValues(n,m,values,O)

    # This will print the policy directions as console text
    showPolicy(n,m,policy,O)

    # This will plot the actual grid with objects as black and values as
    # shades from green to red in increasing numerical order
    xI = [1,1]
    xG = [4,3]
    grid = create_binary_grid(n, m, O)
    plotValues(grid*values,xI,xG,n,m,O)
    path = [[2,1],[3,1],[4,1],[4,2],[4,3]]
    showPath(xI,xG,path,n,m,O)

    

    plt.show()
