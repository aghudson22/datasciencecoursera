print(R.version.string)

source("pollutantmean.R") # define pollutantmean() function
source("complete.R") # define complete() function
source("corr.R") # define corr() function

## pollutantmean-demo commands
pollutantmean("specdata", "sulfate", 1:10)
pollutantmean("specdata", "nitrate", 70:72)
pollutantmean("specdata", "nitrate", 23)

## complete-demo commands
complete("specdata", 1)
complete("specdata", c(2, 4, 8, 10, 12))
complete("specdata", 30:25)
complete("specdata", 3)

## corr-demo commands
cr <- corr("specdata", 150)
head(cr)
summary(cr)

cr <- corr("specdata", 400)
head(cr)
summary(cr)

cr <- corr("specdata", 5000)
summary(cr)
length(cr)

cr <- corr("specdata")
summary(cr)
length(cr)

# quiz question 1
pollutantmean("specdata", "sulfate", 1:10)

# quiz question 2
pollutantmean("specdata", "nitrate", 70:72)

# quiz question 3
pollutantmean("specdata", "sulfate", 34)

# quiz question 4
pollutantmean("specdata", "nitrate")

# quiz question 5
cc <- complete("specdata", c(6, 10, 20, 34, 100, 200, 310))
print(cc$nobs)

# quiz question 6
cc <- complete("specdata", 54)
print(cc$nobs)

# quiz question 7
set.seed(42)
cc <- complete("specdata", 332:1)
use <- sample(332, 10)
print(cc[use, "nobs"])

# quiz question 8
cr <- corr("specdata")
cr <- sort(cr)
set.seed(868)
out <- round(cr[sample(length(cr), 5)], 4)
print(out)

# quiz question 9
cr <- corr("specdata", 129)
cr <- sort(cr)
n <- length(cr)
set.seed(197)
out <- c(n, round(cr[sample(n, 5)], 4))
print(out)

# quiz question 10
cr <- corr("specdata", 2000)
n <- length(cr)
cr <- corr("specdata", 1000)
cr <- sort(cr)
print(c(n, round(cr, 4)))
