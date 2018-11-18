# load packages used
library(dplyr) # used as required for data frame manipulation
library(ggplot2) # used as required for non-base plots

# read in data
# programmer's note: data assumed to be stored in parallel directory "data"
NEI <- readRDS("../data/summarySCC_PM25.rds")
SSC <- readRDS("../data/Source_Classification_Code.rds")

# initiate graphics device
png(filename = "plot5.png", width = 600, height = 600)

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
data_plot_5 <- NEI %>% 
    filter(SCC %in% SCC_motor_vehicle & fips == "24510") %>% 
    group_by(year) %>% 
    summarize(mean_emissions = mean(Emissions, na.rm = TRUE), 
              num_source = n())

# create ggplot2 bar plot showing changes over time
myplot <- ggplot(data = data_plot_5) + 
    geom_col(mapping = aes(x = factor(year), 
                           y = mean_emissions, 
                           fill = num_source)) + 
    scale_fill_distiller(type = "div", palette = "PuOr") + 
    labs(x = "Year", 
         y = "Mean PM2.5 Emissions (tons)", 
         fill = "Number of\nDistinct\nSources", 
         title = "Mean PM2.5 Emissions by Year from Motor Vehicle Sources in Baltimore City", 
         subtitle = "Mean PM2.5 emissions and number of emission sources dramatically increase\nfrom 1999 to 2002, then decrease similarly from 2005 to 2008")
print(myplot)

# close graphics device
dev.off()
