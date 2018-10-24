# load data
outcome <- read.csv(file = "../data/outcome-of-care-measures.csv", 
                    colClasses = "character")
hospital <- read.csv(file = "../data/hospital-data.csv", 
                     colClasses = "character")

# item 1 - sample commands
head(outcome)
ncol(outcome)
nrow(outcome)
names(outcome)
str(outcome)
summary(outcome)
head(hospital)
ncol(hospital)
nrow(hospital)
names(hospital)
str(hospital)
summary(hospital)
outcome[ , 11] <- as.numeric(outcome[ , 11])
hist(outcome[ , 11])

# item 2 - sample commands
source("best.R")
best("TX", "heart attack") # should return "CYPRESS FAIRBANKS MEDICAL CENTER"
best("TX", "heart failure") # should return "FORT DUNCAN MEDICAL CENTER"
best("MD", "heart attack") # should return "JOHNS HOPKINS HOSPITAL, THE"
best("MD", "pneumonia") # should return "GREATER BALTIMORE MEDICAL CENTER"
best("BB", "heart attack") # should return error: invalid state
best("NY", "hert attack") # should return error: invalid outcome


# item 3 - sample commands
source("rankhospital.R")
rankhospital("TX", "heart failure", 4) # should return "DETAR HOSPITAL NAVARRO"
rankhospital("MD", "heart attack", "worst") # should return "HARFORD MEMORIAL HOSPITAL"
rankhospital("MN", "heart attack", 5000) # should return NA


# item 4 - sample commands
source("rankall.R")
head(rankall("heart attack", 20), 10) # should return first line <NA>, AK
tail(rankall("pneumonia", "worst"), 3) # should return first line "MAYO CLINIC HEALTH SYSTEM - NORTHLAND, INC, WI
tail(rankall("heart failure"), 10) # should return first line WELLMONT HAWKINS COUNTY MEMORIAL HOSPITAL, TN


# quiz question 1
best("SC", "heart attack")

# quiz question 2
best("NY", "pneumonia")

# quiz question 3
best("AK", "pneumonia")

# quiz question 4
rankhospital("NC", "heart attack", "worst")

# quiz question 5
rankhospital("WA", "heart attack", 7)

# quiz question 6
rankhospital("TX", "pneumonia", 10)

# quiz question 7
rankhospital("NY", "heart attack", 7)

# quiz question 8
r <- rankall("heart attack", 4)
as.character(subset(r, state == "HI")$hospital)

# quiz question 9
r <- rankall("pneumonia", "worst")
as.character(subset(r, state == "NJ")$hospital)

# quiz question 10
r <- rankall("heart failure", 10)
as.character(subset(r, state == "NV")$hospital)

