using Random, Distributions, LinearAlgebra

struct LabeledPoint
    point
    label
    LabeledPoint(point, label) = new(point, label)
end 

function parse_iris_row(line)
    """
    sepal_length, sepal_width, petal_length, petal_width, class
    """
    row = split(line, ",")
    measurements = [parse(Float64, value) for value in row[1:end-1]]
    # class is e.g. "Iris-virginica"; we just want "virginica"
    label = split(row[end], "-")[end]

    return LabeledPoint(measurements, label)
end

parse_iris_row("5.1,3.5,1.4,0.2,Iris-setosa")
