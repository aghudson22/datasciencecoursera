# load packages used
library(dplyr) # used as required for data frame manipulation
library(ggplot2) # used as required for non-base plots

# read in data
# programmer's note: data assumed to be stored in parallel directory "data"
NEI <- readRDS("../data/summarySCC_PM25.rds")
SSC <- readRDS("../data/Source_Classification_Code.rds")

# initiate graphics device
png(filename = "plot3.png", width = 600, height = 600)

# construct summary data frame
data_plot_3 <- NEI %>% 
    filter(fips == "24510") %>%
    group_by(year, type) %>% 
    summarize(sum_emissions = sum(Emissions, na.rm = TRUE))

# create ggplot2 faceted barplot showing changes over time in each type
myplot <- ggplot(data = data_plot_3) + 
    facet_wrap(facets = vars(type), 
               ncol = 2) + 
    geom_col(mapping = aes(x = factor(year), 
                           y = sum_emissions, 
                           fill = factor(year)), 
             show.legend = FALSE) + 
    scale_fill_brewer(type = "qual", palette = "Pastel2") + 
    theme_dark() + 
    labs(x = "Year", 
         y = "Total PM2.5 Emissions (tons)", 
         title = "Total PM2.5 Emissions by Year and Source Type in Baltimore City", 
         subtitle = "Point source type increased from 1999 to 2005, then decreased to 2008 \nNonpoint, on-road, non-road source types generally decrease from 1999 to 2008")
print(myplot)

# close graphics device
dev.off()
