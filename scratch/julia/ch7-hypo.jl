using Random, Distributions

function normal_approximation_to_binomial(n, p)
    mu = n * p
    sigma = sqrt(n * (1-p) * p)
    return mu, sigma 
end

function normal_cdf(lo, mu=0, sigma=1)
   return cdf(Normal(mu, sigma), lo) 
end

# function normal_probability_below(lo, mu=0, sigma=1)
#   return normal_cdf(lo, mu, sigma)
# end

function normal_probability_above(lo, mu=0, sigma=1)
   return 1 - normal_cdf(lo, mu, sigma)
end

function normal_probability_between(lo, hi, mu=0, sigma=1)
   return normal_cdf(hi,mu, sigma) - normal_cdf(lo, mu, sigma)
end

function normal_probability_outside(lo, hi, mu=0, sigma=1)
    return 1 - normal_probability_between(lo, hi, mu, sigma)
end

@assert normal_cdf(0, 0 ,1)==0.5


function normal_upper_bound(probability, mu=0, sigma=1)
   return quantile(Normal(mu, sigma), probability)
end

function normal_lower_bound(probability, mu=0, sigma=1)
   return quantile(Normal(mu, sigma), 1 - probability)   
end

function normal_two_sided_bounds(probability, mu=0, sigma=1)
   tail_probability = (1 - probability)/2

   upper_bound = normal_lower_bound(tail_probability, mu, sigma)

   lower_bound = normal_upper_bound(tail_probability, mu, sigma)

   return  lower_bound, upper_bound
end

mu_0, sigma_0 = normal_approximation_to_binomial(1000, 0.5)

@assert mu_0 == 500 
@assert 15.8 < sigma_0 < 15.9
# 95% bounds based on assumption p is 0.5
lo, hi = normal_two_sided_bounds(0.95, mu_0, sigma_0)

# actual mu and sigma based on p = 0.55
mu_1, sigma_1 = normal_approximation_to_binomial(1000, 0.55)

# a type 2 error means we fail to reject the null hypothesis
# which will happen when X is still in our original interval
type_2_probability = normal_probability_between(lo, hi, mu_1, sigma_1)
power = 1 - type_2_probability      # 0.887
@assert 0.886 < power < 0.888

function two_sided_p_value(x, mu = 0, sigma = 1)
    """
    How likely are we to see a value at least as extreme as x (in either
    direction) if our values are from a N(mu, sigma)?
    """
   if (x >= mu)
        # x is greater than the mean, so the tail is everything greater than x
        return 2 * normal_probability_above(x, mu, sigma) 
   else
        # x is less than the mean, so the tail is everything less than x
        return 2 * normal_probability_below(x, mu, sigma)
   end
end


two_sided_p_value(529.5, mu_0, sigma_0)   # 0.062

# TODO: Add julia code Monte-Carlo simulation



two_sided_p_value(531.5, mu_0, sigma_0)   # 0.0463

# TODO: Two sided tests


p_hat = 525 / 1000
mu = p_hat
sigma = sqrt(p_hat * (1 - p_hat) / 1000)   # 0.0158

normal_two_sided_bounds(0.95, mu, sigma)        # [0.4940, 0.5560]

p_hat = 540 / 1000
mu = p_hat
sigma = sqrt(p_hat * (1 - p_hat) / 1000) # 0.0158
normal_two_sided_bounds(0.95, mu, sigma) # [0.5091, 0.5709]