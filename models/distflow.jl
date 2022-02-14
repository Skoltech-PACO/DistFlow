"""
DistFlow for distribution power system

Luis Lopez Diaz - luis.lopez@skoltech.ru
v20221302
"""

using JuMP, Ipopt, SparseArrays

include(pwd() * "/core/network.jl")

# Network dimensiones and setup
n = length(bus[:bus_i])                         # Number of nodes
e = length(branch[:fbus])                       # Number of lines
g = length(gen[:bus]);                          # Number of generators
Pcc = 1                                         # Feeder index
Sb = 1e3                                        # Base power

# Sets
N = Int.(bus[:bus_i])                           # set of buses
fr = Int.(branch[:fbus])                        # From nodes
to = Int.(branch[:tbus])                        # To nodes
E = collect([fr[i], to[i]] for i in 1:e);       # Set of lines
G = Int.(gen[:bus])                             # Set of generators

# Parameters
Pd = sparsevec(N, bus[:Pd]/Sb)                  # Active power demand
Qd = sparsevec(N, bus[:Qd]/Sb)                  # Reactive power demand
r = branch[:r]
x = branch[:x]
R = sparse(fr, to, r)                           # Resistance
X = sparse(fr, to, x)                           # Reactance
Vmin = sparsevec(N, bus[:Vmin].^2)              # Minimum voltage
Vmax = sparsevec(N, bus[:Vmax].^2)              # Maximum voltage
lmax = sparse(fr, to, branch[:rateA])
θ_pf = acos(0.8)
pmax = lmax*cos(θ_pf)
qmax = lmax*sin(θ_pf)
# Creating model
model = Model(Ipopt.Optimizer)                  # Model

# Extra functions for creating model
bf(i,j) = ([i,j] in E) == true

## variables
@variable(model, v[i in N])                             # voltage
@variable(model, pn[i in N])                            # active power balance per node
@variable(model, qn[i in N])                             # reactive power balance per node
@variable(model, l[i in N, j in N; bf(i,j) == true])    # current
@variable(model, p[i in N, j in N; bf(i,j) == true])    # active power flow
@variable(model, q[i in N, j in N; bf(i,j) == true])    # reactive power flow


## constraints
# engineering limits
@constraint(model, c1[i in N], Vmin[i] <= v[i] <= Vmax[i])
@constraint(model, c4[i in N, j in N; bf(i,j) == true], 0 <= p[i,j] <= pmax[i,j])
@constraint(model, c5[i in N, j in N; bf(i,j) == true], 0 <= q[i,j] <= qmax[i,j])

# Boundary limits
@constraint(model, c6[i in Pcc], v[i] == 1)

# nodal balance
@constraint(model, c7[j in N], pn[j] == Pd[j])
@constraint(model, c8[j in N], qn[j] == Qd[j])

# branch flow
@constraint(model, c9[i in N, j in N; bf(i,j) == true], p[i,j] == pn[j] + sum(p[j,k] for (r,k) in E if r == j))
@constraint(model, c10[i in N, j in N; bf(i,j) == true], q[i,j] == qn[j] + sum(q[j,k] for (r,k) in E if r == j))
@constraint(model, c11[i in N, j in N; bf(i,j) == true], v[i] - v[j] == 2(R[i,j]*p[i,j] + X[i,j]*q[i,j]) - (R[i,j]^2 + X[i,j]^2)*l[i,j])
@constraint(model, c14[i in N, j in N; bf(i,j) == true], l[i,j]*v[i] == p[i,j]^2 + q[i,j]^2)

@objective(model, Min, 0)

optimize!(model)

# Checking voltaje and active power flow
print(sqrt.(value.(v)))
print("\n")
print(map(x -> (x), value.(p)))
