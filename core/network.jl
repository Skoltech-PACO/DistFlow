# Read data and create network data matrix

# Importing functions
include(pwd() * "/misc/mat2jul.jl")

# Importing data
filename = "case5.jl"
include(pwd() * "/data/" * filename)


# Data in tuples
bus = mat2jul(bus_header, bus_data)
gen = mat2jul(gen_header, gen_data)
gencost = mat2jul(gencost_header, gencost_data)
branch = mat2jul(branch_header, branch_data)
