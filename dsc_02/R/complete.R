complete <- function(directory, id = 1:332) {
    ## `directory` is a character vector of length 1 indicating 
    ## the location of the CSV files
    
    ## `id` is an integer vector indicating the monitor ID numbers 
    ## to be used
    
    ## Return a data frame of the form: 
    ## id nobs
    ## 1  117
    ## 2  1041
    ## ...
    ## where `id` is the monitor ID number and `nobs` is the 
    ## number of complete cases
    
    
    
    ## Programmer Note: `directory` taken to be path WITHIN 
    ## directory "data" in standard four-directory structure: 
    ## R, data, text, figures
    
    ## initialize vector; numbers of observations will be stored 
    ## here
    nobs <- numeric(length = length(id))
    
    ## loop through data files, gathering complete case info
    for(k in seq_along(id)) {
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
        
        ## calculate number of complete cases in current data file
        comp <- sum(complete.cases(stationdata))
        
        ## store number of complete cases in nobs vector
        nobs[k] <- comp
    }
    
    ## create and return data frame with station IDs and numbers of 
    ## complete cases
    return(data.frame(id, nobs))
}
