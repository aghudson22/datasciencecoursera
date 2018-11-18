# load packages used
library(dplyr) # used as required for data frame manipulation
library(ggplot2) # used as required for non-base plots

# read in data
# programmer's note: data assumed to be stored in parallel directory "data"
NEI <- readRDS("../data/summarySCC_PM25.rds")
SSC <- readRDS("../data/Source_Classification_Code.rds")

# initiate graphics device
png(filename = "plot4.png", width = 600, height = 600)

# identify coal combustion codes; use mutated column to search full contents 
# of SCC.Level.* columns instead of abbreviated contents in Short.Name column
SCC_coal_combust <- SSC %>% 
    mutate(full_desc = paste(SCC.Level.One, SCC.Level.Two, SCC.Level.Three, 
                             SCC.Level.Four, sep = "/")) %>% 
    filter(grepl("combust", full_desc, ignore.case = TRUE) & 
               grepl("coal", full_desc, ignore.case = TRUE)) %>% 
    select(SCC)
SCC_coal_combust <- SCC_coal_combust[[1]]

# construct filtered and summarized data frame
data_plot_4 <- NEI %>% 
    filter(SCC %in% SCC_coal_combust) %>% 
    group_by(year) %>% 
    summarize(mean_emissions = mean(Emissions, na.rm = TRUE), 
              num_source = n())

# create ggplot2 bar plot showing changes over time
myplot <- ggplot(data = data_plot_4) + 
    geom_col(mapping = aes(x = factor(year), 
                           y = mean_emissions, 
                           fill = num_source)) + 
    scale_fill_distiller(type = "seq", palette = "Oranges", direction = 1) + 
    theme_bw() + 
    labs(x = "Year", 
         y = "Mean PM2.5 Emissions (tons)", 
         fill = "Number of\nDistinct\nSources", 
         title = "Mean PM2.5 Emissions by Year from Coal Combustion Sources Across U.S.", 
         subtitle = "Mean PM2.5 emissions generally decreases from 1999 to 2008 \nTotal number of sources generally increases")
print(myplot)

# close graphics device
dev.off()
