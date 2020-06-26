
function normal_approximation_to_binomial(n, p)
    mu = n * p
    sigma = sqrt(n * (1-p) * p)
    return mu, sigma 
end

mu, sigma = normal_approximation_to_binomial(1000, 0.5)
println(mu)
println(sigma)

@assert mu == 500 
@assert 15.8 < sigma < 15.9