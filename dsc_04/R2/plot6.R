# load packages used
library(dplyr) # used as required for data frame manipulation
library(ggplot2) # used as required for non-base plots

# read in data
# programmer's note: data assumed to be stored in parallel directory "data"
NEI <- readRDS("../data/summarySCC_PM25.rds")
SSC <- readRDS("../data/Source_Classification_Code.rds")

# initiate graphics device
png(filename = "plot6.png", width = 600, height = 600)

# identify motor vehicle codes; use mutated column to search full contents 
# of SCC.Level.* columns instead of abbreviated contents in Short.Name column
SCC_motor_vehicle <- SSC %>% 
    mutate(full_desc = paste(SCC.Level.One, SCC.Level.Two, SCC.Level.Three, 
                             SCC.Level.Four, sep = "/")) %>% 
    filter(grepl("motor", full_desc, ignore.case = TRUE) & 
               grepl("vehicle", full_desc, ignore.case = TRUE)) %>% 
    select(SCC)
SCC_motor_vehicle <- SCC_motor_vehicle[[1]]

# construct filtered and summarized data frame
data_plot_6 <- NEI %>% 
    filter(SCC %in% SCC_motor_vehicle & fips %in% c("24510", "06037")) %>% 
    group_by(fips, year) %>% 
    summarize(mean_emissions = mean(Emissions, na.rm = TRUE), 
              num_source = n())

# create ggplot2 line plot grouped by fips showing changes over time
myplot <- ggplot(data = data_plot_6, mapping = aes(x = factor(year), 
                                         y = mean_emissions, 
                                         group = factor(fips), 
                                         color = factor(fips))) + 
    geom_line() + 
    geom_point(mapping = aes(size = num_source)) + 
    scale_color_brewer(type = "qual", 
                       palette = "Dark2", 
                       labels = c("Los Angeles\nCounty", "Baltimore City")) + 
    theme_bw() + 
    labs(x = "Year", 
         y = "Mean PM2.5 Emissions (tons)", 
         size = "Number of\nDistinct\nSources", 
         color = "Location", 
         title = "Mean PM2.5 Emissions by Year from Motor Vehicle Sources\nin Los Angeles County and Baltimore City", 
         subtitle = "Mean PM2.5 emissions substantially higher in Los Angeles County across all years\nBaltimore City mean emissions increased after 1999 and decreased after 2005,\n    opposite trend in Los Angeles County")
print(myplot)

# close graphics device
dev.off()
