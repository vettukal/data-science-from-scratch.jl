import StatsBase: countmap 
function raw_majority_vote(labels)
    votes = countmap(labels)
    votes = sort(collect(votes), by=x->x[2], rev=true)
    winner = votes[1][1]
    return winner
end

@assert raw_majority_vote(['a', 'b', 'c', 'b']) == 'b'


function majority_vote(labels)
    """Assumes that labels are ordered from nearest to farthest."""
    vote_counts = countmap(labels)
    vote_counts = sort(collect(vote_counts), by=x->x[2], rev=true)
    winner = vote_counts[1][1]
    if(length(vote_counts) == 1)
        return winner
    end
    
    winner_count= vote_counts[1][2]
    second_count = vote_counts[2][2]
    # num_winners = length([count
                    #    for count in vote_counts.values()
                    #    if count == winner_count])

    if (winner_count != second_count)
        return winner                     # unique winner, so return it
    else
        return majority_vote(labels[1:length(labels)-1]) # try again without the farthest
    end
end

# Tie, so look at first 4, then 'b'
@assert majority_vote(['a', 'b', 'c', 'b', 'a'])== 'b' 


using Distances

struct LabeledPoint
    point
    label
    LabeledPoint(point, label) = new(point, label)
end 

function knn_classify(k, labeled_points, new_point)

    by_distance = sort(labeled_points, by = x -> SqEuclidean()(x.point, new_point))

    k_nearest_labels = [lp.label for lp in by_distance[1:k]]

    return majority_vote(k_nearest_labels)
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

data = open(f->read(f,String), "iris.data")
irislines = []
for i in split(data, "\n")
    push!(irislines,i)
end

iris_data = [parse_iris_row(line) for line in irislines]
using Random
Random.seed!(12)
function split_data(origdata, prob)
    """Split data into fractions [prob, 1 - prob]"""
    data = copy(origdata)                    # Make a shallow copy
    data = shuffle(data)              # because shuffle modifies the list.
    cut = Int(floor(length(data) * prob))       # Use prob to find a cutoff
    return data[1:cut], data[cut+1:end]     # and split the shuffled list there.
end

iris_train, iris_test = split_data(iris_data, 0.70)
@assert length(iris_train) == 0.7*150
@assert length(iris_test) == 0.3 * 150

confusion_matrix = Dict()
let num_correct = 0

    for iris in iris_test
        if(iris.label == "virginica")
            # continue
        end
        predicted = knn_classify(5, iris_train, iris.point)
        actual = iris.label

        if predicted == actual
            num_correct += 1
        end

        confusion_matrix[(predicted, actual)] = get(confusion_matrix,(predicted, actual),0) + 1
    end

    pct_correct = num_correct / length(iris_test)

    print(pct_correct)
    print( confusion_matrix)

end
