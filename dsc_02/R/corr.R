corr <- function(directory, threshold = 0) {
    ## `directory` is a character vector of length 1 indicating 
    ## the location of the CSV files
    
    ## `threshold` is a numberic vector of length 1 indicating the 
    ## number of completely observed observations (on all 
    ## variables) required to compute the correlation between 
    ## nitrate and sulfate; the default is 0
    
    ## Return a numeric vector of correlations
    ## NOTE: Do not round the result!
    
    
    
    ## Programmer Note: `directory` taken to be path WITHIN 
    ## directory "data" in standard four-directory structure: 
    ## R, data, text, figures
    
    ## source complete() function
    source("complete.R")
    
    ## use complete() to gather numbers of complete cases
    stations <- complete(directory)
    
    ## establish subset vector using threshold value
    sub <- stations$nobs > threshold
    
    ## subset stations using logical threshold vector
    stations <- stations[sub, ]
    
    ## create vector of station IDs
    id <- stations$id
    
    ## initialize vector of correlations
    correl <- numeric(length = length(id))
    
    ## loop through subsetted data files, calculating correlations
    for(k in seq_along(correl)){
        ## before reading data file, must determine number of zeros 
        ## to prepend to current station id
        ## hard-coded 3 since id vector may not include stations with 
        ## 3 digits in ID
        numzeros <- 3 - nchar(id[k])
        
        ## now, create character string of zeros to be prepended to 
        ## station ID
        prepend <- paste(rep("0", times = numzeros), collapse = "")
        
        ## create filename using paste()
        filename <- paste(prepend, id[k], ".csv", sep = "", collapse = "")
        
        ## now, construct path to current station CSV file
        path <- file.path("..", "data", directory, filename)
        
        ## read in the CSV file
        stationdata <- read.csv(path)
        
        ## calculate and store correlation between pollutant values
        correl[k] <- cor(x = stationdata$nitrate, y = stationdata$sulfate, 
                         use = "complete.obs")
    }
    
    ## return populated vector of correlation values
    return(correl)
}
