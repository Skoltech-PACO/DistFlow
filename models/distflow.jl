# Distribution system modeling
# DistFlow equations based on Barran and Wu paper

using JuMP, Ipopt, SparseArrays

include(pwd() * "/core/network.jl")

# Network dimensiones
n = length(bus[:bus_i])                         # Number of nodes
e = length(branch[:fbus])                       # Number of lines
g = length(gen[:bus]);                          # Number of generators

# Sets
N = Int.(bus[:bus_i])                           # set of buses
fr = Int.(branch[:fbus])                        # From nodes
to = Int.(branch[:tbus])                        # To nodes
E = collect([fr[i], to[i]] for i in 1:e);       # Set of lines
G = Int.(gen[:bus])                             # Set of generators

# Parameters
Sb = 100                                        # Base power
Pd = sparsevec(N, bus[:Pd]/Sb)                  # Active power demand
Qd = sparsevec(N, bus[:Qd]/Sb)                  # Reactive power demand
r = branch[:r]
x = branch[:x]
R = sparse(fr, to, r)                           # Resistance
X = sparse(fr, to, x)                           # Reactance
Vmin = sparsevec(N, bus[:Vmin].^2)              # Minimum voltage
Vmax = sparsevec(N, bus[:Vmax].^2)              # Maximum voltage
lmax = sparse(fr, to, branch[:rateA])

# Creating model
model = Model(Ipopt.Optimizer)                  # Model

# Extra functions for creating model
bf(i,j) = ([i,j] in E) == true

# Variables
@variable(model, Vmin[i] <= v[i in N] <= Vmax[i])
@variable(model, 0 <= l[i in N, j in N; bf(i,j) == true] <= lmax[i,j])
@variable(model, p[i in N, j in N; bf(i,j) == true])
@variable(model, q[i in N, j in N; bf(i,j) == true])

# Variable for OPF
# @variable(model, 0 <= pg[i in N])
# @variable(model, qg[i in N])

# Constraints
@constraint(model, c1[i in N, j in N; bf(i,j) == true], p[i,j] == Pd[j] + R[i,j]*l[i,j] + sum(p[j,k] for (h,k) in E if h == j))
@constraint(model, c2[i in N, j in N; bf(i,j) == true], q[i,j] == Qd[j] + X[i,j]*l[i,j] + sum(q[j,k] for (h,k) in E if h == j))
@constraint(model, c3[i in N, j in N; bf(i,j) == true], v[j] == v[i] - 2*(R[i,j]*p[i,j] + X[i,j]*q[i,j]) + (R[i,j]^2 + X[i,j]^2)*l[i,j])
@constraint(model, c4[i in N, j in N; bf(i,j) == true], l[i,j]*v[i] == p[i,j]^2 + q[i,j]^2)

# Future constraints
#@constraint(model, c6[i in N, j in N; bf(i,j) == true], l[i,j] <= 100)
#@constraint(model, c5, sum(pg) == sum(Pd) + sum(R[i,j]*l[i,j] for (i,j) in E))
#@constraint(model, v[1] == 1)
#@constraint(model, c7[i in N[2:end]], qg[i] == 0)

# Objective
# @objective(model, Min, [1; 4; 3; 2; 5]'*pg)
# Feasibility problem
@objective(model, Min, 0)

optimize!(model)

# Checking voltaje and active power flow
print(sqrt.(value.(v)))
print("\n")
print(map(x -> (x), value.(p)))
