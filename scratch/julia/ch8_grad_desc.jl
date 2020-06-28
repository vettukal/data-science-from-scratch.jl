using Random, Distributions, LinearAlgebra
using Plots; pyplot()


function sum_of_squares(v)
    """Computes the sum of squared elements in v"""
    return dot(v, v)
end


function difference_quotient(f, x, h)
    return (f(x + h) - f(x)) / h
end

function square(x)   
    return x * x
end

function derivative(x)
    return 2 * x
end

@assert 4 <= difference_quotient(square, 2, .001) <=4.01

function squared_distance(v, w)
    """Computes (v_1 - w_1) ** 2 + ... + (v_n - w_n) ** 2"""
    return sum_of_squares((v - w))
end

function distance(v, w)
    """Computes the distance between v and w"""
    return sqrt(squared_distance(v, w))
end

function partial_difference_quotient(f, v, i, h)
        """Returns the i-th partial difference quotient of f at v"""
        # w = [v_j + (h if j == i else 0) for j, v_j in enumerate(v)]
        w = copy(v) 
        for j in 1:length(v)
            v_j = v[j]   
            if(j==i) 
                w[j] = v_j + h
            else
                w[j] = v_j 
            end
        end

        return (f(w) - f(v)) / h
end


function add(v, w)
    """Adds corresponding elements"""
    @assert length(v) == length(w)
    return v+w 
end



function scalar_multiply(c, v)
    """Multiplies every element by c"""
    return [c * v_i for v_i in v]
end

function gradient_step(v, gradient, step_size)
    """Moves `step_size` in the `gradient` direction from `v`"""
    @assert length(v) == length(gradient)
    step = scalar_multiply(step_size, gradient)
    return add(v, step)
end

function sum_of_squares_gradient(v)
    return [2 * v_i for v_i in v]
end


function custom_fun(v)
    sign = -1
    if(v[2] > 4)
        sign = 1
    end
    return v[1]*v[1] + sign * v[2]*v[2] + 16
end

function estimate_gradient(f, v, h = 0.0001)
    return [partial_difference_quotient(f, v, i, h) for i in 1:length(v)]
end
# let v = [rand(-10: 10) for i in 0:2]
let v = [2.0, 2.0]
    for epoch in 1:1000
        # grad = sum_of_squares_gradient(v)    # compute the gradient at v
        grad = estimate_gradient( custom_fun,v)
        v = gradient_step(v, grad, -0.001)    # take a negative gradient step
    end

    # @assert distance(v, [0, 0]) < 0.001    # v should be close to 0
    @assert custom_fun(v) < .1
end



xs = -10: 11
actuals = [derivative(x) for x in xs]
estimates = [difference_quotient(square, x, 0.001) for x in xs]

# plot to show they're basically the same
plot(title = "Actual Derivatives vs. Estimates")
plot!(xs, actuals, label="Actual", seriestype = :scatter, color = "red", markersize = 7)       # red  x
plot!(xs, estimates, label="Estimate", seriestype = :scatter, color = "blue", markershape= :x)   # blue +
# plot(legend=loc=9)
# plot.show()



result = estimate_gradient(sum_of_squares,[2.0 2.0])
println(result) #should be equal to [4.0 4.0]

function error(v)
    x, y, slope, intercept = v
    predicted = slope * x + intercept
    error = (predicted - y)^2
    return error
end

println(error([2, 1 , 3, 5]))

ex_vector = [2.0, 1.0 , 2.0, 5.0]
println(partial_difference_quotient(error,ex_vector,3,.001))
  
function linear_gradient(x, y, theta)
    vector = [x,y, theta...] 
    error_diff_estimate = [partial_difference_quotient(error,vector,i,.001)
                        for i in 3:4]
                        
end 
error_diff_estimate = linear_gradient(2.0,1.0, [2.0, 5.0])
println(error_diff_estimate)

inputs = [(x, 20 * x + 5) for x in -50: 49]

function vector_mean(vectors)
    """Computes the element-wise average"""
    n = length(vectors)
    return scalar_multiply(1/n, sum(vectors))
end

ud = Uniform(-1,1)
let theta = [rand(ud), rand(ud)]

learning_rate = 0.001
for epoch in 1:3000
    grad = vector_mean([linear_gradient(x,y, theta) for (x,y) in inputs])

    theta = gradient_step(theta, grad, -learning_rate)
    println(epoch, theta)
end

slope, intercept = theta
@assert 19.9 < theta[1] < 20.1
@assert 4.9 < intercept < 5.1
end

#finished
