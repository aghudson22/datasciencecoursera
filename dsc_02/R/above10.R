above10 <- function(x) { 
    # x - numeric vector
    use <- x > 10 # returns logical vector indicating elements greater than 10
    x[use] # return subset indexed by logical vector
}
