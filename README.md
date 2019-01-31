# Tackle-non-linearity-in-IP-objective-function

The problem is Mixed-Integer Non-Linear Programming due to presence of a square-root term in the objective function

First strategy is to solve using BARON, the most well-known MINLP solver. NEOS (Network-Enabled Optimization System) Server is a free internet-based service that provides access to more than 60 state-of-the-art solvers for solving numerical optimization problems. This is coded in AMPL. However, the results are not promising for our problem.

Second stategy is to use Constraint Programming to find feasible solutions that give a better objective value than the one returned by BARON. Here we add an additional constraint -- The total number of Warehouses allowed is 3 or less -- to narrow down the search-space. This was implemented using OPL with IBM ILOG CPLEX CP Optimizer.
