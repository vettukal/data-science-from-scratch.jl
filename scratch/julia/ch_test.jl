using Random, Distributions, LinearAlgebra

v = [1 2 3]



av = rand(-10: 10)

let v = [rand(-10: 10) for i in 0:2]
    println(v)
    println(v+v)
    for epoch in 1:10
        println(v)
        v = v + v
    end
    println(v)
end
