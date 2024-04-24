#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: sonia martinez
"""

# Please do not distribute or publish solutions to this
# exercise. You are free to use these problems for educational purposes, please refer to the source.

import numpy as np
import matplotlib.pyplot as plt
from matplotlib import colors

from mazemods import maze
from mazemods import makeMaze
from mazemods import collisionCheck
from mazemods import makePath
from mazemods import getPathFromActions
from mazemods import getCostOfActions
from mazemods import stayWestCost
from mazemods import stayEastCost




"""
  Search the deepest nodes in the search tree first.
 
  Your search algorithm needs to return a list of actions
  and a path that reaches the goal.  
  Make sure to implement a graph search algorithm.
  Your algorithm also needs to return the cost of the path. 
  Use the getCostOfActions function to do this.
  Finally, the algorithm should return the number of visited
  nodes in your search.
 
"""
def depthFirstSearch(xI,xG,n,m,O):
    Q = []
    visited = []
    parents = []
    
    Q.append(xI)
    visited.append(xI)
    parents.append(xI)
    
    while len(Q) > 0:
        s = Q.pop(0)
        if s == xG:
            P = [xG]
            while parents[visited.index(s)] != s:
                s = parents[visited.index(s)]
                P.insert(0, s)
        else:
            A = []
            for a in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
                if not collisionCheck(s, a, O):
                    A.append((s[0] + a[0], s[1] + a[1]))
                    
            for sX in A:
                if sX not in visited:
                    visited.append(sX)
                    Q.insert(0, sX)
                    parents.append(s)
                    
    actions = []
    for i in range(len(P) - 1):
        actions.append((P[i + 1][0] - P[i][0], P[i + 1][1] - P[i][1]))
    
    cost = getCostOfActions(xI, actions, O)
    numNodes = len(visited)
    actions.pop()
    plot = makePath(xI,xG,getPathFromActions(xI,actions),n,m,O)
    
    return actions, cost, numNodes, plot



"""
  Search the shallowest nodes in the search tree first [p 85].
 
  Your search algorithm needs to return a list of actions
  and a path that reaches the goal. Make sure to implement a graph 
  search algorithm.
  Your algorithm also needs to return the cost of the path. 
  Use the getCostOfActions function to do this.
  Finally, the algorithm should return the number of visited
  nodes in your search.

"""
def breadthFirstSearch(xI,xG,n,m,O):
    Q = []
    visited = []
    parents = []
    
    Q.append(xI)
    visited.append(xI)
    parents.append(xI)
    
    while len(Q) > 0:
        s = Q.pop(0)
        if s == xG:
            P = [xG]
            while parents[visited.index(s)] != s:
                s = parents[visited.index(s)]
                P.insert(0, s)
        else:
            A = []
            for a in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
                if not collisionCheck(s, a, O):
                    A.append((s[0] + a[0], s[1] + a[1]))
                    
            for sX in A:
                if sX not in visited:
                    visited.append(sX)
                    Q.append(sX)
                    parents.append(s)
                    
    actions = []
    for i in range(len(P) - 1):
        actions.append((P[i + 1][0] - P[i][0], P[i + 1][1] - P[i][1]))
    
    cost = getCostOfActions(xI, actions, O)
    numNodes = len(visited)
    actions.pop()
    plot = makePath(xI,xG,getPathFromActions(xI,actions),n,m,O)
    
    return actions, cost, numNodes, plot

"""
  Search the nodes with least cost first. 
  
  Your search algorithm needs to return a list of actions
  and a path that reaches the goal. Make sure to implement a graph 
  search algorithm.
  Your algorithm also needs to return the total cost of the path using
  either the stayWestCost or stayEastCost function.
  Finally, the algorithm should return the number of visited
  nodes in your search.
"""
def DijkstraSearch(xI,xG,n,m,O,cost='westCost'):
    Q = []
    visited = []
    parents = []
    C = []
    
    Q.append(xI)
    visited.append(xI)
    parents.append(xI)
    C.append(0)

    while len(Q) > 0:
        u = Q.pop(0)
        
        if u == xG:
            P = [xG]
            while parents[visited.index(u)] != u:
                u = parents[visited.index(u)]
                P.insert(0, u)
        else:
            A = []
            for a in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
                if not collisionCheck(u, a, O):
                    A.append((u[0] + a[0], u[1] + a[1]))
                    
            for v in A:
                if v not in visited:
                    visited.append(v)
                    Q.append(v)
                    parents.append(u)
                    if cost == 'westCost':
                        C.append(C[visited.index(u)] + u[0] ** 2)
                    else:
                        C.append(C[visited.index(u)] + (n - 2 + u[0]) ** 2)
                else:
                    if cost == 'westCost':
                        if C[visited.index(u)] < C[visited.index(v)]:
                            parents[visited.index(v)] = u
                            Q.append(v)
                    else:
                        if C[visited.index(u)] < C[visited.index(v)]:
                            parents[visited.index(v)] = u
                            Q.append(v)
                        
    actions = []
    for i in range(len(P) - 1):
        actions.append((P[i + 1][0] - P[i][0], P[i + 1][1] - P[i][1]))
        
    cost = getCostOfActions(xI, actions, O)
    numNodes = len(visited)
    actions.pop()
    plot = makePath(xI,xG,getPathFromActions(xI,actions),n,m,O)

    return actions, cost, numNodes, plot

"""
   A heuristic function estimates the cost from the current state to the nearest
   goal.  This heuristic is trivial.

   """
def nullHeuristic(state,goal):
   return 0

def manhattanHeuristic(state,goal):
    return abs(state[0] - goal[0]) + abs(state[1] - goal[1])

def euclideanHeuristic(state,goal):
    return np.sqrt((state[0] - goal[0]) ** 2 + (state[1] - goal[1]) ** 2)

"Search the node that has the lowest combined cost and heuristic first."
"""The function uses a function heuristic as an argument. We have used
  the null heuristic here first, you should redefine heuristics as part of 
  the homework. 
  Your algorithm also needs to return the total cost of the path using
  getCostofActions functions. 
  Finally, the algorithm should return the number of visited
  nodes during the search.
"""
def aStarSearch(xI,xG,n,m,O,heuristic=nullHeuristic):
    Q = []
    visited = []
    parents = []
    C = []
    heur = []
    
    Q.append(xI)
    visited.append(xI)
    heur.append(heuristic(xI,xG))
    parents.append(xI)
    C.append(0)

    while len(Q) > 0:
        u = Q.pop(0)
        
        if u == xG:
            P = [xG]
            while parents[visited.index(u)] != u:
                u = parents[visited.index(u)]
                P.insert(0, u)
        else:
            A = []
            for a in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
                if not collisionCheck(u, a, O):
                    A.append((u[0] + a[0], u[1] + a[1]))
                    
            for v in A:
                if v not in visited:
                    visited.append(v)
                    heur.append(heuristic(xI,xG))
                    Q.append(v)
                    parents.append(u)
                    
                    Qtemp = [None] * len(Q)
                    heurtemp = []
                    for i in range(len(Q)):
                        Qtemp[i] = Q[i]
                        heurtemp.append(heur[visited.index(Q[i])])
                    
                    Q = []
                    for i in range(len(Qtemp)):
                        Q.append(Qtemp[heurtemp.index(min(heurtemp))])
                        heurtemp[heurtemp.index(min(heurtemp))] = float('inf')

    actions = []
    for i in range(len(P) - 1):
        actions.append((P[i + 1][0] - P[i][0], P[i + 1][1] - P[i][1]))
        
    cost = getCostOfActions(xI, actions, O)
    numNodes = len(visited)
    actions.pop()
    plot = makePath(xI,xG,getPathFromActions(xI,actions),n,m,O)

    return actions, cost, numNodes, plot
  
def isWall(x,O):
    nextx = [x[i] for i in range(len(x))]
    for l in range(len(O)):
        # Find boundaries of current obstacle
        west, east = [O[l][0], O[l][1]]
        south, north = [O[l][2], O[l][3]]
        # Check if nextx is contained in obstacle boundaries
        if west <= nextx[0] <= east and south <= nextx[1] <= north:
            return True
    # If we iterate through whole list and don't trigger the "if", then no collisions
    return False
    
# Plots the path
def showPath(xI,xG,path,n,m,O):
    gridpath = makePath(xI,xG,path,n,m,O)
    fig, ax = plt.subplots(1, 1) # make a figure + axes
    ax.imshow(gridpath) # Plot it
    ax.invert_yaxis() # Needed so that bottom left is (0,0)
     
if __name__ == '__main__':
    # Run test using smallMaze.py (loads n,m,O)
    # from smallMaze import *
    from mediumMaze import *  # try these mazes too
    # from bigMaze import *     # try these mazes too
    # from testMaze import *
    maze(n,m,O) # prints the maze
    
# =============================================================================
#     xI = (1,1)
#     xG = (20,8)
# =============================================================================
    
    xI = (1,1)
    xG = (34,16)
    
# =============================================================================
#     xI = (1,1)
#     xG = (35,35)
# =============================================================================
    
    actions, cost, numNodes, plot = depthFirstSearch(xI,xG,n,m,O)
    showPath(xI,xG,getPathFromActions(xI,actions),n,m,O)
    print('Depth-first cost: ' + str(cost))
    print('Depth-first number of nodes explored: ' + str(numNodes))
    
    actions, cost, numNodes, plot = breadthFirstSearch(xI,xG,n,m,O)
    showPath(xI,xG,getPathFromActions(xI,actions),n,m,O)
    print('Breadth-first cost: ' + str(cost))
    print('Breadth-first number of nodes explored: ' + str(numNodes))
    
    actions, cost, numNodes, plot = DijkstraSearch(xI,xG,n,m,O,'westCost')
    showPath(xI,xG,getPathFromActions(xI,actions),n,m,O)
    print('Dijkstra west cost: ' + str(cost))
    print('Dijkstra west number of nodes explored: ' + str(numNodes))
    
    actions, cost, numNodes, plot = DijkstraSearch(xI,xG,n,m,O,'eastCost')
    showPath(xI,xG,getPathFromActions(xI,actions),n,m,O)
    print('Dijkstra east cost: ' + str(cost))
    print('Dijkstra east number of nodes explored: ' + str(numNodes))
    
    actions, cost, numNodes, plot = aStarSearch(xI,xG,n,m,O,manhattanHeuristic)
    showPath(xI,xG,getPathFromActions(xI,actions),n,m,O)
    print('Manhattan heuristic cost: ' + str(cost))
    print('Manhattan number of nodes explored: ' + str(numNodes))
    
    actions, cost, numNodes, plot = aStarSearch(xI,xG,n,m,O,euclideanHeuristic)
    showPath(xI,xG,getPathFromActions(xI,actions),n,m,O)
    print('Euclidean heuristic cost: ' + str(cost))
    print('Euclidean number of nodes explored: ' + str(numNodes))
    
# =============================================================================
#     # Sample collision check
#     x, u = (5,4), (1,0)
#     testObs = [[6,6,4,4]]
#     collided = collisionCheck(x,u,testObs)
#     print('Collision!' if collided else 'No collision!')
#     
#     # Sample path plotted to goal
#     xI = (1,1)
#     xG = (20,1)
#     actions = [(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0),(0,1),
#                (1,0),(1,0),(1,0),(0,-1),(1,0),(1,0),(1,0),(1,0),(1,0),(1,0)]
#     path = getPathFromActions(xI,actions)
#     showPath(xI,xG,path,n,m,O)
#     
#     # Cost of that path with various cost functions
#     simplecost = getCostOfActions(xI,actions,O)
#     westcost = stayWestCost(xI,actions,O)
#     eastcost = stayEastCost(xI,actions,O)
#     print('Basic cost was %d, stay west cost was %d, stay east cost was %d' %
#           (simplecost,westcost,eastcost))
# =============================================================================
    
    
