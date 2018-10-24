rankall <- function(outcome, num = "best") {
    ## Function takes character value outcome and integer/character 
    ## value num
    ## Function returns data frame in which each line is the name of 
    ## the hospital in each state for which the mortality rate for 
    ## the specified outcome is: 
    ## lowest if num = "best", highest is num = "worst", or ranked 
    ## num from lowest to highest if num is integer
    
    
    
    
    ## For each state, find the hospital of the given rank
    
    ## Return a data frame with hospital names and the 
    ## (abbreviated) state name
    
    ## Read outcome data
    oocdata <- read.csv("../data/outcome-of-care-measures.csv", 
                        colClasses = "character")
    
    ## Check that outcome is valid
    ## store valid outcomes
    allow_outcome <- c("heart attack", 
                       "heart failure", 
                       "pneumonia")
    
    ## check whether outcome is valid
    if (!(outcome %in% allow_outcome)) {
        stop("invalid outcome")
    }
    
    ## determine column with mortality rate corresponding to outcome
    if (outcome == "heart attack") {
        clmn <- 11
    } else if (outcome == "heart failure") {
        clmn <- 17
    } else if (outcome == "pneumonia") {
        clmn <- 23
    }
    
    ## coerce necessary column from character to numeric
    oocdata[ , clmn] <- as.numeric(oocdata[ , clmn])
    
    ## determine subset of valid data; subset by non-missing rate
    subset <- !is.na(oocdata[ , clmn])
    
    ## create subsetted data frame
    oocsubset <- oocdata[subset, ]
    
    ## create order of indices using desired rate and hospital name
    ord <- order(oocsubset[ , clmn], oocsubset[ , 2])
    
    ## create reordered data frame
    oocorder <- oocsubset[ord, ]
    
    ## create list of split data frames by state
    oocstates <- split(oocorder, oocorder[ , 7])
    
    ## create vector of state values; to be used in return object
    state <- sort(unique(oocorder[ , 7]))
    
    ## create empty vector of hospital names; to be used in return object
    hospital <- character(length = length(state))
    
    ## locate desired ranking hospital once for each state in data
    for (st in state) {
        ## determine index to be used for extracted hospital name within state
        if (num == "best") {
            ind <- 1
        } else if (num == "worst") {
            ind <- nrow(oocstates[[st]])
        } else {
            ind <- num
        }
        
        ## locate state index corresponding to current state; then 
        ## extract hospital name corresponding to given rank within 
        ## state, and store name in position of hospital vector that 
        ## corresponds to position of current state
        hospital[which(state == st)] <- oocstates[[st]][ind, 2]
    }
    
    ## return data frame containing states and hospitals within each state 
    ## of requested rank for specified mortality rate
    return(data.frame(hospital, state, row.names = state))
}
