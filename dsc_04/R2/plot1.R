# load packages used
library(dplyr) # used as required for data frame manipulation
library(ggplot2) # used as required for non-base plots

# read in data
# programmer's note: data assumed to be stored in parallel directory "data"
NEI <- readRDS("../data/summarySCC_PM25.rds")
SSC <- readRDS("../data/Source_Classification_Code.rds")

# initiate graphics device
png(filename = "plot1.png", width = 600, height = 600)

# construct summary data frame
data_plot_1 <- NEI %>% 
    group_by(year) %>% 
    summarize(sum_emissions = sum(Emissions, na.rm = TRUE))

# create base R barplot of data over time
par(mar = c(4, 6, 2, 2))
barplot(height = data_plot_1$sum_emissions, 
        names.arg = data_plot_1$year, 
        col = cm.colors(4), 
        main = "Total U.S. PM2.5 Emissions Appear to Decrease over Time", 
        xlab = "Year", 
        ylim = c(0, 8e6), 
        axes = FALSE)
marks <- seq(from = 0, to = 8e6, by = 1e6)
axis(side = 2, 
     at = marks, 
     labels = format(marks, scientific = FALSE), 
     las = 1, 
     cex.axis = 0.8)
mtext(text = "Total PM2.5 Emissions (tons)", 
      side = 2, 
      line = 4.5)
text(x = seq(from = 0.725, length.out = 4, by = 1.2), 
     y = round(data_plot_1$sum_emissions) + 0.2e6, 
     labels = round(data_plot_1$sum_emissions), 
     adj = c(0.5, 0))

# close graphics device
dev.off()
