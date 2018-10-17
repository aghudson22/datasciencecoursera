pollutantmean <- function(directory, pollutant, id = 1:332) {
    ## `directory` is a character vector of length 1 indicating 
    ## the location of the CSV files
    
    ## `pollutant` is a character vector of length 1 indicating 
    ## the name of the pollutant for which we will calculate the 
    ## mean; either "sulfate" or "nitrate".
    
    ## `id` is an integer vector indicating the monitor ID numbers 
    ## to be used
    
    ## Return the mean of the pollutant across all monitors listed 
    ## in the `id` vector (ignoring NA values)
    ## NOTE: Do not round the result!
    
    
    
    ## Programmer Note: `directory` taken to be path WITHIN 
    ## directory "data" in standard four-directory structure: 
    ## R, data, text, figures
    
    ## initialize empty numeric vector; pollutant data will be 
    ## stored here
    data <- numeric(length = 0L)
    
    ## loop through data files, appending pollutant data as needed
    for(i in id) {
        ## before reading data file, must determine number of zeros 
        ## to prepend to current station id
        ## hard-coded 3 since id vector may not include stations with 
        ## 3 digits in ID
        numzeros <- 3 - nchar(i)
        
        ## now, create character string of zeros to be prepended to 
        ## station ID
        prepend <- paste(rep("0", times = numzeros), collapse = "")
        
        ## create filename using paste()
        filename <- paste(prepend, i, ".csv", sep = "", collapse = "")
        
        ## now, construct path to current station CSV file
        path <- file.path("..", "data", directory, filename)
        
        ## read in the CSV file
        stationdata <- read.csv(path)
        
        ## append pollutant data from current file
        data <- c(data, stationdata[[pollutant]])
    }
    
    ## calculate and return mean of relevant data; remove NAs
    return(mean(data, na.rm = TRUE))
}
