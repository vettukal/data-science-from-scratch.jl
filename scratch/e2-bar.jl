using Plots; pyplot()

movies = ["Annie Hall", "Ben-Hur", "Casablanca", "Gandhi", "West S1de Story"]
num_oscars = [5, 11, 3, 8, 10]

years = ["pf-5", "pf-6", "pf-7", "pf-8", "pf-9"]
gdp = [8014, 7957, 7929, 8041, 8048]

plot(years, gdp, seriestype= :bar)
plot!(ylabel = "Counts out of 40026", ylims = (0,8500),legend=false )
plot!(title= "Alogrithms based on xid" )