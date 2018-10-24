rankhospital <- function(state, outcome, num = "best") {
    ## Function takes character value state (postal abbreviation), 
    ## character value outcome, and integer/character value num
    ## Function returns name of hospital for which the mortality rate 
    ## for the specified outcome in the specified state is: 
    ## lowest if num = "best", highest if num = "worst", or ranked 
    ## num from lowest to highest if num is integer
    
    ## Read outcome data
    oocdata <- read.csv("../data/outcome-of-care-measures.csv", 
                        colClasses = "character")
    
    ## Check that state and outcome are valid
    ## store valid states and outcomes
    allow_state <- unique(oocdata[ , 7])
    allow_outcome <- c("heart attack", 
                       "heart failure", 
                       "pneumonia")
    
    ## check whether state is valid
    if (!(state %in% allow_state)) {
        stop("invalid state")
    }
    
    ## check whether outcome is valid
    if (!(outcome %in% allow_outcome)) {
        stop("invalid outcome")
    }
    
    ## determine column with mortality rate date corresponding to outcome
    if (outcome == "heart attack") {
        clmn <- 11
    } else if (outcome == "heart failure") {
        clmn <- 17
    } else if (outcome == "pneumonia") {
        clmn <- 23
    }
    
    ## coerce necessary column from character to numeric
    oocdata[ , clmn] <- as.numeric(oocdata[ , clmn])
    
    ## determine subset of valid data; subset by state and non-missing rate
    subset <- (oocdata[ , 7] == state) & (!is.na(oocdata[ , clmn]))
    
    ## create subsetted data frame
    oocsubset <- oocdata[subset, ]
    
    ## create order of indices using desired rate and hospital name
    ord <- order(oocsubset[ , clmn], oocsubset[ , 2])
    
    ## create reordered data frame
    oocorder <- oocsubset[ord, ]
    
    ## determine index to be used for return value
    if (num == "best") {
        ind <- 1
    } else if (num == "worst") {
        ind <- nrow(oocorder)
    } else {
        ind <- num
    }
    
    ## return hospital name in requested row of reordered/subsetted data frame
    return(oocorder[ind, 2])
}
