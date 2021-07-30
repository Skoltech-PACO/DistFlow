# Funcion para convertir las matrices de Matpower en
# tuplas para manejarlas con Julia

function mat2jul(labels::Tuple, info::Matrix{Float64})
    l = length(labels)
    f = size(info)[2]

    # Condition added for gencost matrix
    if f > l
        cost_coef = Tuple(Symbol("c", string(x)) for x in (f-l-1):-1:0)
        labels = Tuple([collect(labels); collect(cost_coef)])
        l = length(labels)
    end

    data = [Vector{Float64}() for i in 1:l]
    for i in 1:l
        data[i] = info[:,i]
    end
    tp = NamedTuple{labels}(data)
    return tp
end
