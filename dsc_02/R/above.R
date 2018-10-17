above <- function(x, n = 10) { 
    # x - numeric vector
    # n - value to which vector is compared - default value 10
    use <- x > n # returns logical vector indicating elements greater than n
    x[use] # return subset indexed by logical vector
}
