using Plots; pyplot()


years = ["pf-5", "pf-6", "pf-7", "pf-8", "pf-9"]
gdp = [8014, 7957, 7929, 8041, 8048]

# Plot the graph and create a line chart, years on x-axis, gdp on y-axis
plot(years, gdp, marker='o', linestyle=:solid, linecolor=( :green))
# add a title
plot!(title = "Algorithms")
# add a label to the y-axis
plot!(ylabel = "Counts \$") 