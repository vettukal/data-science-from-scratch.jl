using LinearAlgebra
function predict(x,beta)
   return x ⋅ beta
end 

function error(x, y, beta)
    return predict(x, beta) - y
end

function squared_error(x, y, beta)
    return error(x, y, beta) ^ 2
end


x = [1, 2, 3]
y = 30
beta = [4, 4, 4]  # so prediction = 4 + 8 + 12 = 24




@assert error(x, y, beta) == -6
@assert squared_error(x, y, beta) == 36