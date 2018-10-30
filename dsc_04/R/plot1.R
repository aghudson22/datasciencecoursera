## read in data
## programmer's note: location of data file presumes folder structure 
## with folders "data" and "R" in same location
power <- read.table(file = "../data/household_power_consumption.txt", 
                    header = TRUE, 
                    sep = ";", 
                    na.strings = "?", 
                    colClasses = c(rep("character", times = 2), 
                                   rep("numeric", times = 7)), 
                    nrows = 2075259)

# define datetime column to combine Date and Time as POSIXlt objects
power$datetime <- strptime(x = paste(power$Date, power$Time), 
                           format = "%d/%m/%Y %H:%M:%S", 
                           tz = "Europe/Paris")

# subset data retaining only dates 2007-02-01, 2007-02-02
subsetdates <- c(as.Date("2007-02-01"), 
                 as.Date("2007-02-02"))
power <- subset(power, as.Date(datetime) %in% subsetdates)

## open PNG graphics device
png(filename = "plot1.png")

## initiate plot
with(power, hist(Global_active_power, 
                 col = "red", 
                 xlab = "Global Active Power (kilowatts)", 
                 main = "Global Active Power"))

## close PNG graphics device
dev.off()
