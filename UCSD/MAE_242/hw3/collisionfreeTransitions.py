
"""

The functions in this file calculate obstacle free probability
transitions for one of the environments in mdps

"""

uSet = [(1,0),(0,1),(-1,0),(0,-1)]
def neighbor(x, O):

    """
    Input: a state and the obstacle (grid environment)
    Output: the indices of the neighbors of x that are obstacle free

         The neighbors of a state are listed as entries in a list as
         [right_neigh, up_neigh, left_neig, down_neigh] The function
         returns a list of lists of Booleans (True or False), for any
         possible action u in uSet

    """
    
    freed = [False]*4
    for idx, u in enumerate(uSet):
        freed[idx] = not collisionCheck(x, u, O)
    return freed

def valid_neighbor(u):
    """
        Input: an intended direction u 
        Output: the indices of the neighbors where there is a chance of motion, regardless of
        obstacles

        For example if u = (1,0) (right) with index 0 (or (0,-1), left, with index 2)
                the robot can move up or down, corresponding to indices 1 and 3
                if u = (0,1) (or (0,-1)) the robot can move to locations corresponding to
                indices 0 or 2

    """
    
    u_idx = uSet.index(u)
    if u_idx%2 == 0:
        return [1,3]
    else:
        return [0,2]

def next_prob(x, u, eta, O):
    """
    Inputs:
      x: List of 2D input coordinates
      u: List of transitions, in USet.
      eta: probability parameter
      gridname: Name of robot working space
    
    Outputs:
      nStates: List of states that can be reached given (x,u) with a positive probability
      nprob: List of probability of reaching each state in nStates
    """
    # Assign probabilities: P[0] = P_ii (self), P[1] = intended, P[2] = left
    # P[3] = right
    P = [0,0,0,0]

    # Sum with input tuple and add to list
    states = [x, tuple(map(sum, zip(x, u)))] 
       # the zip function creates a list of pairs map applies sum to
       # each pair the list, and returns a list given by sums of pairs
       # tuple creates a tuple object, here it is applied to a list,
       # then changed to a tuple; tuples allow for faster iterations,
       # and better access to elements

    # Compute the locations of neighbors that are free for any possible action   
    freed = neighbor(x, O)

    # Now we use a particular u to verify if we can move to the intended location,
    # and calculate the prob of motion:
    if freed[uSet.index(u)] == False:
        # this means you can't move where intended,
        # so this probability is added to the probability of staying put
        P[0] = 1-eta 
    else:
        P[1] = 1-eta
        
    # We also calculate the probability of moving to the other possible adjacent locations
    for id, vn_idx in enumerate(valid_neighbor(u)):
        states.append(tuple(map(sum, zip(x, uSet[vn_idx]))))
        if freed[vn_idx] == False:
            # if you can't move to the adjacent location, you need to add this to the prob of staying put
            P[0] = P[0] + eta/2
        else:
            P[2+id] = eta/2

    # New probability and states: list of the probabilities p_{ij}(u)
    # for transitioning from i to j using u, and states j
    nprob = []
    nstates = []
    for id, prob in enumerate(P):
        if prob>0:
            nprob.append(P[id])
            nstates.append(states[id])

    return nprob, nstates

