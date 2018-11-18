# load packages used
library(dplyr) # used as required for data frame manipulation
library(ggplot2) # used as required for non-base plots

# read in data
# programmer's note: data assumed to be stored in parallel directory "data"
NEI <- readRDS("../data/summarySCC_PM25.rds")
SSC <- readRDS("../data/Source_Classification_Code.rds")

# initiate graphics device
png(filename = "plot2.png", width = 600, height = 600)

# construct summary data frame
data_plot_2 <- NEI %>% 
    filter(fips == "24510") %>%
    group_by(year) %>% 
    summarize(sum_emissions = sum(Emissions, na.rm = TRUE))

# create base R barplot of data over time
barplot(height = data_plot_2$sum_emissions, 
        names.arg = data_plot_2$year, 
        col = colorRampPalette(c("forestgreen", "steelblue"))(4), 
        main = "Total Baltimore City PM2.5 Emissions Generally Decrease over Time", 
        xlab = "Year", 
        ylab = "Total PM2.5 Emissions (tons)", 
        ylim = c(0, 4000), 
        las = 1, 
        cex.axis = 0.8)
mtext(text = "General trend is decreasing, but slight increase from 2002 to 2005", 
      side = 3, line = -0.75)
text(x = seq(from = 0.725, length.out = 4, by = 1.2), 
     y = round(data_plot_2$sum_emissions) + 150, 
     labels = round(data_plot_2$sum_emissions), 
     adj = c(0.5, 0))

# close graphics device
dev.off()
