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
        w = []
        for j in 1:length(v)
            v_j = v[j]   
            if(j==i) 
                w[j] = v_j + h
            else
                w[j] = 0
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

let v = [rand(-10: 10) for i in 0:2]

    for epoch in 1:1000
        grad = sum_of_squares_gradient(v)    # compute the gradient at v
        v = gradient_step(v, grad, -0.01)    # take a negative gradient step
    end

    @assert distance(v, [0, 0, 0]) < 0.001    # v should be close to 0

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

