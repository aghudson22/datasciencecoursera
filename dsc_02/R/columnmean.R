columnmean <- function(y, removeNA = TRUE) { 
    # y - matrix or data frame for which we find column means
    # removeNA - logical value, determines whether mean() removes missing values 
    # default value - TRUE
    
    nc <- ncol(y) # calculate number of columns of input object
    means <- numeric(length = nc) # initialize empty vector in which to store means
    for(i in 1:nc) { # execute code once for each integer from 1 to nc
        means[i] <- mean(y[, i], na.rm = removeNA) # calculate mean of all values in
        # column i and store in means vector
    }
    means # return vector of means
}
