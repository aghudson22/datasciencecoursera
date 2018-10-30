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
png(filename = "plot4.png")

## store previous parameters
oldpar <- par(no.readonly = TRUE)
## modify parameters for multiple-plot page
par(mfrow = c(2, 2))

## create first plot; top left
with(power, plot(datetime, Global_active_power, 
                 type = "s", 
                 xlab = "", 
                 ylab = "Global Active Power"))

## create second plot; top right
with(power, plot(datetime, Voltage, 
                 type = "l", 
                 xlab = "datetime", 
                 ylab = "Voltage"))

## create third plot; bottom left
## start with blank plot; specifying all three sets of points forces R 
## to draw plotting region that will contain all points
with(power, plot(rep(datetime, times = 3), 
                 c(Sub_metering_1, Sub_metering_2, Sub_metering_3), 
                 type = "n", 
                 xlab = "", 
                 ylab = "Energy submetering"))
## annotate plot
## draw each set of points separately with different color
with(power, points(datetime, Sub_metering_1, 
                   type = "S", 
                   col = "black"))
with(power, points(datetime, Sub_metering_2, 
                   type = "S", 
                   col = "red"))
with(power, points(datetime, Sub_metering_3, 
                   type = "S", 
                   col = "blue"))
## draw legend
legend("topright", 
       lty = "solid", 
       col = c("black", "red", "blue"), 
       legend = paste0("Sub_metering_", 1:3), 
       bty = "n")

## create fourth plot; bottom right
with(power, plot(datetime, Global_reactive_power, 
                 type = "l", 
                 xlab = "datetime", 
                 ylab = "Global_reactive_power"))

## cleanup: reset old parameters, remove parameter variable
par(oldpar)
rm(oldpar)

## close PNG graphics device
dev.off()
