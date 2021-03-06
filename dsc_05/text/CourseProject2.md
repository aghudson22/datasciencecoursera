---
title: "Exploring Weather Events by Economic Impact and Public Health Effects"
author: "Alex Hudson"
date: "2018-12-09"
output: 
  html_document:
    toc: TRUE
    toc_float: TRUE
    keep_md: TRUE
---

## Synopsis

In this analysis, we explore a storm database collected by the United States National Oceanic and Atmospheric Administration (NOAA). The data include estimates of fatalities, injuries, property damage, and crop damage caused by each storm listed in the database. We use these estimates to try to determine the impact of each storm in the database, both in terms of public health and in terms of economic effects. To gauge public health, we sum together fatalities and injuries, while to gauge economic effects, we sum together property damages and crop damages. Further, since different weather effects occur in different volumes, we consider average effects for each individual event as well as average effects per year of data. Among the events with the greatest casualty rates were tsunamis, tornadoes, and excessive heat events. Meanwhile, among the events with greatest economic impacts were hurricanes, storm tides, and floods.

## Initial Setup


```r
## Set all chunks to show code, hide messages, hide warnings, and store figures.
knitr::opts_chunk$set(echo = TRUE, 
                      message = FALSE, 
                      warning = FALSE, 
                      fig.path = "../figures/")

## Load relevant packages.
library(readr)
library(dplyr)
library(stringr)
library(lubridate)
library(tidyr)
library(ggplot2)
```

## Questions

This analysis is an attempt to answer the following two questions.

1. Across the United States, which types of events are most harmful with respect to population health?
2. Across the United States, which types of events have the greatest economic consequences?

## Download and Read in Data

The following code chunk downloads the data file after checking whether a file with the same name and the same size already exists.


```r
if(!(file.exists("../data/StormData.csv.bz2") & file.size("../data/StormData.csv.bz2") == 49177144)){
    download.file(url = "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", 
                  destfile = "../data/StormData.csv.bz2", 
                  method = "curl")
}
```

The following code chunk reads in the data file via the function `readr::read_csv()`.


```r
stormdata <- read_csv("../data/StormData.csv.bz2", progress = FALSE)
```

## Data Processing

Due to the size of the data obtained and the number of items that require some amount of cleaning or processing, the task of data processing is split into several smaller tasks.

### Standardize Event Type Names

Something we notice upon examining the names used to describe weather events is that there is some inconsistency in them. So we need to take a few steps to clean this up. One of the inconsistencies is in the use of capitalization in the event names. Our first task will be to set all of the event names to use the same capitalization.


```r
stormdata <- stormdata %>% 
    mutate(EVTYPE = str_to_upper(str_to_lower(EVTYPE)))
```

The next thing we'll do is assemble a list of what we deem to be acceptable names for events. In intermediate steps, this will help us determine exactly how we need to modify remaining names. Later in our analysis, this will serve as a filtering mechanism by which we can remove data whose name is not helpful for determining the type of weather event. These names are taken from the data set's accompanying documentation, which provided guidelines by which weather events can be classified as each of these items.


```r
acceptable_evtype <- c("ASTRONOMICAL LOW TIDE", 
                       "AVALANCHE", 
                       "BLIZZARD", 
                       "COASTAL FLOOD", 
                       "COLD/WIND CHILL", 
                       "DEBRIS FLOW", 
                       "DENSE FOG", 
                       "DENSE SMOKE", 
                       "DROUGHT", 
                       "DUST DEVIL", 
                       "DUST STORM", 
                       "EXCESSIVE HEAT", 
                       "EXTREME COLD/WIND CHILL", 
                       "FLASH FLOOD", 
                       "FLOOD", 
                       "FREEZING FOG", 
                       "FROST/FREEZE", 
                       "FUNNEL CLOUD", 
                       "HAIL", 
                       "HEAT", 
                       "HEAVY RAIN", 
                       "HEAVY SNOW", 
                       "HIGH SURF", 
                       "HIGH WIND", 
                       "HURRICANE/TYPHOON", 
                       "ICE STORM", 
                       "LAKESHORE FLOOD", 
                       "LAKE-EFFECT SNOW", 
                       "LIGHTNING", 
                       "MARINE HAIL", 
                       "MARINE HIGH WIND", 
                       "MARINE STRONG WIND", 
                       "MARINE THUNDERSTORM WIND", 
                       "RIP CURRENT", 
                       "SEICHE", 
                       "SLEET", 
                       "STORM TIDE", 
                       "STRONG WIND", 
                       "THUNDERSTORM WIND", 
                       "TORNADO", 
                       "TROPICAL DEPRESSION", 
                       "TROPICAL STORM", 
                       "TSUNAMI", 
                       "VOLCANIC ASH", 
                       "WATERSPOUT", 
                       "WILDFIRE", 
                       "WINTER STORM", 
                       "WINTER WEATHER")
```

Our next task will be to attempt to classify some of the inconsistent event names as one of those in the list above. While items like typos, such as transposition of two letters, can be difficult to detect, others are easier. For example, a common abbreviation of `"THUNDERSTORM"` in the data was `"TSTM"`, which can be easily corrected. Another common alternative convention was to record `"HAIL"` as `"HAIL ###"`, where `###` was an attempt to record the size of the hail in the event. In the following, we create a list of regular expressions (the first item in each row) which will be replaced with text (the second item in each row) which allows events to be properly classified. Some are helpful for fixing many different event names, while others correct single event names. This list is not exhaustive, and does not fix everything; the focus was on maximizing the number of event names corrected in the data.


```r
replacements <- rbind(c("T(HUNDERSTOR|ST)MS?", "THUNDERSTORM"), 
                      c("WINDS", "WIND"), 
                      c("^HAIL.*", "HAIL"), 
                      c("(FLDG?)|(FLOODS?I?N?G?)", "FLOOD"), 
                      c("CURRENTS", "CURRENT"), 
                      c("WINDCHILL", "WIND CHILL"), 
                      c("^.*(STREAM|RIVER).*$", "FLOOD"), 
                      c("^.*(FOREST|BRUSH|GRASS|WILD).*$", "WILDFIRE"),
                      c("^.*MIX$", "WINTER WEATHER"), 
                      c("WIND ?(\\(|[G0-9]).*$", "WIND"), 
                      c("^.*[^T]BURST.*$", "THUNDERSTORM WIND"), 
                      c("^.*LAKE.*SNOW.*$", "LAKE-EFFECT SNOW"), 
                      c("^.*SURGE.*$", "STORM TIDE"), 
                      c("^.*SLIDE.*$", "DEBRIS FLOW"), 
                      c("^.*SURF.*$", "HIGH SURF"), 
                      c("(^FOG$)|(^.*DENSE FOG$)", "DENSE FOG"), 
                      c("TORNADO(S)?(ES)? ?[DF]?[0-5]?", "TORNADO"), 
                      c("^HURRICANE .*$", "HURRICANE/TYPHOON"), 
                      c("(^EXTREME COLD$)|(^EXTREME WIND CHILL( TEMPERATURES)?$)|(^WIND CHILL$)|(^RECORD COLD$)", "EXTREME COLD/WIND CHILL"), 
                      c("(^HURRICANE$)|(^TYPHOON$)", "HURRICANE/TYPHOON"), 
                      c("(^FOG AND COLD TEMPERATURES$)|(^ICE FOG$)", "FREEZING FOG"), 
                      c("^SNOW$", "HEAVY SNOW"), 
                      c("^RAIN$", "HEAVY RAIN"), 
                      c("^URBAN FLOOD$", "FLOOD"), 
                      c("^GUSTY WIND$", "STRONG WIND"), 
                      c("(^RECORD WARMTH$)|(^RECORD HEAT$)|(^EXTREME HEAT$)", "EXCESSIVE HEAT"), 
                      c("^FUNNEL( CLOUDS)?$", "FUNNEL CLOUD"), 
                      c("^COLD$", "COLD/WIND CHILL"), 
                      c("(^FROST$)|(^FREEZE$)", "FROST/FREEZE"), 
                      c("^HEAT WAVE$", "HEAT"), 
                      c("^THUNDERSTORM WINDS$", "THUNDERSTORM WIND"), 
                      c("^WATERSPOUTS$", "WATERSPOUT"), 
                      c("^HEAVY SNOW[ \\-]SQUALLS?$", "HEAVY SNOW"), 
                      c("^HEAVY RAINS$", "HEAVY RAIN"), 
                      c("^(SMALL|DEEP|LATE SEASON|NON SEVERE) HAIL$", "HAIL"), 
                      c("^SLEET STORM$", "SLEET"))
```

All that remains for our work with event type names is to process this list of changes. The following loop does exactly this.


```r
for(i in seq_along(replacements[ , 1])){
    stormdata <- stormdata %>% 
        mutate(EVTYPE = str_replace(EVTYPE, replacements[i, 1], replacements[i, 2]))
}
```

### Standardize Property Damage Values

The information on property damage is split between two columns, one of which is listed as a number, and one of which is primarily listed as one of the letters "K," "M," or "B." These are common abbreviations for the words "thousand," "million," and "billion," respectively. This leads us to think that the second property damage column is meant to tell us about the order magnitude of the property damage. Before we begin the set of operations to process this information, we note what appears to be an obvious error. The record in the data whose value of `REFNUM` is `605943` appears to have an error in its second property damage column. It lists `"B"`, which stands for billions of dollars; however, its information in the `REMARKS` column mentions millions of dollars. Thus, before we go any further, we change `"B"` to `"M"` here.


```r
stormdata[stormdata$REFNUM == 605943, "PROPDMGEXP"] <- "M"
```

Now, we need to deal with a large quantity of missing values in the second property damage column. Given that we think this column is a supplement to the first property damage column, we presume that missing values are intended to convey that the first property damage column is complete on its own. So, in the second column, we replace missing values with `"0"`. We also standardize capitalization in this column to avoid confusion over items like `"m"` versus `"M"`.


```r
stormdata <- stormdata %>% 
    mutate(PROPDMGEXP = str_replace_na(PROPDMGEXP, replacement = "0"), 
           PROPDMGEXP = str_to_upper(PROPDMGEXP))
```

Next, we create a list of items to be replaced in the second property damage column. As before, for each row in this list, the first item is the string (or regular expression) to be replaced, and the second is the string with which it will be replaced. We replace letters with corresponding powers of 10, and we replace seemingly invalid entries, such as `"?"`, with `"NA"`.


```r
replacements2 <- rbind(c("H", "2"), 
                       c("K", "3"), 
                       c("M", "6"), 
                       c("B", "9"), 
                       c("(\\?)|(\\+)|(\\-)", "NA"))
```

Also as before, the following code will process these changes. After these changes, valid values have all been converted to integers, but are stored as character strings. So we coerce these integers to numeric values as well.


```r
for (i in seq_along(replacements2[ , 1])){
    stormdata <- stormdata %>% 
        mutate(PROPDMGEXP = str_replace(PROPDMGEXP, replacements2[i, 1], replacements2[i, 2]))
}
stormdata <- stormdata %>% 
    mutate(PROPDMGEXP = as.numeric(PROPDMGEXP))
```

Finally, we make use of the second property damage column as a numeric exponent. We calculate actual property damage values by taking the value in the first property damage column and multiplying it by the number 10 raised to the exponent in the second property damage column.


```r
stormdata <- stormdata %>% 
    mutate(PROPDMG_TOTAL = PROPDMG * (10 ^ PROPDMGEXP))
```

### Standardize Crop Damage Values

We note that information on crop damage is stored in the data in an identical manner to that by which the information on property damage is stored. Thus, we apply an identical process to clean and process the information on crop damage. First, we replace missing values with zero and standardize capitalization of letters.


```r
stormdata <- stormdata %>% 
    mutate(CROPDMGEXP = str_replace_na(CROPDMGEXP, replacement = "0"), 
           CROPDMGEXP = str_to_upper(CROPDMGEXP))
```

Then, we create a list of letters and characters that will be replaced by numbers or missing values.


```r
replacements3 <- rbind(c("K", "3"), 
                       c("M", "6"), 
                       c("B", "9"), 
                       c("\\?", "NA"))
```

Next, we use a loop to process these replacements and convert the resulting column to a numeric variable.


```r
for (i in seq_along(replacements3[ , 1])){
    stormdata <- stormdata %>% 
        mutate(CROPDMGEXP = str_replace(CROPDMGEXP, replacements3[i, 1], replacements3[i, 2]))
}
stormdata <- stormdata %>% 
    mutate(CROPDMGEXP = as.numeric(CROPDMGEXP))
```

Finally, we combine the two crop damage columns into a single column by multiplying the number in the first column by the number 10 raised to the power in the second column.


```r
stormdata <- stormdata %>% 
    mutate(CROPDMG_TOTAL = CROPDMG * (10 ^ CROPDMGEXP))
```

## Data Transformations

At this point, we have roughly clean data that tells us the type of weather event, the numbers of fatalities and injuries associated by that event, and estimates of property damage and crop damage (in US dollars) caused by that event. Our goal for this analysis is to determine weather event types that produce the greatest effects in terms of public health and economic impact. So, we need to create variables that may measure these effects.

### Create Measure of Public Health Impact

First, we'll create a variable that measures public health impact. To do so, we sum up the fatalities and injuries associated with a given weather event.


```r
stormdata <- stormdata %>% 
    mutate(CASUALTIES = FATALITIES + INJURIES)
```

### Create Measure of Economic Impact

Second, we'll create a variable that measures economic impact. For this, we'll sum the estimates of property damage and crop damage associated with a given weather event.


```r
stormdata <- stormdata %>% 
    mutate(DMG_TOTAL = PROPDMG_TOTAL + CROPDMG_TOTAL)
```

## Data Filtering

At this point, our data includes much information which may inadvertently skew our results. So, as our final step before looking for the most impactful weather event types, we'll remove some of the data.

### Remove Unclassified Events

We spent some time earlier reclassifying weather event types, but we also noted that our list of reclassifications was not exhaustive. With unlimited time, we could reclassify 100% of the data, but we rarely have unlimited time. So, we'll remove from the data any weather types that were not successfully classified as one of the 48 types discussed in the data set's documentation. Many of the items removed are hard-to-detect typos, such as `"THUNDERSTROM WIND"`. Others include events whose name includes multiple classification options, such as `"THUNDERSTORM WIND/HAIL"` or `"EXCESSIVE HEAT/DROUGHT"`, which could conceivably be classified as two different events. To avoid possibly introducing bias into the data by attempting to classify these as one or the other event type, we simply remove them.


```r
stormdata <- stormdata %>% 
    filter(EVTYPE %in% acceptable_evtype)
```

### Remove Incomplete Years

Finally, one item explored in the data was the number of unique event types (after removing items that could not be classified) in each year of the data. First, this showed that data were collected from 1950 to 2011 in this data set. Second, it showed that the types of data recorded changed over time. Up until 1993, very few unique event types were recorded. In 1993, the amount of data recorded increased dramatically. Another distinct increase happened in 2005, but the magnitude of this increase was smaller. So, to try and strike a balance between quantity of data and quality of data, we choose to keep the data starting in the year 1993.


```r
stormdata <- stormdata %>% 
    filter(year(mdy_hms(BGN_DATE)) >= 1993)
```

## Results

Now that our data are processed, cleaned, clarified, and filtered, we can start to dig into our questions. To assess the weather event types with the greatest impacts on public health and economy, we'll use two measures. To detect events for which even a single occurrence can have a major impact, we'll measure the average effects per event. To detect events which can happen more frequently and have large impacts in greater volume, we'll also measure the average effects per year in the data. For the latter, we'll include all years in the filtered data for every weather event type, instead of just year(s) in which each type occurred, so that each weather event type is on roughly the same scale.

We'll begin with public health effects. First, we calculate the average number of casualties per individual occurrence of each type of weather event. Then, we calculate the average number of casualties per year, using the number of years in the filtered data.


```r
range_years <- range(year(mdy_hms(stormdata$BGN_DATE)))
num_years <- range_years[2] - range_years[1] + 1

casualties_by_type <- stormdata %>%
    group_by(EVTYPE) %>%
    summarize(AVG_CASUALTIES_EVENT = mean(CASUALTIES, na.rm = TRUE),
              AVG_CASUALTIES_YEAR = sum(CASUALTIES, na.rm = TRUE) / num_years)
```

Next, we split the data into two groups, one for each type of measurement. We rank the weather event types by each measurement within each group, and filter to retain only the top seven weather event types by each measurement. The resulting calculations are then shown in the following paneled bar plot.


```r
casualties_by_type_2 <- casualties_by_type %>% 
    gather(key = "Rate", value = "casualties", AVG_CASUALTIES_EVENT, AVG_CASUALTIES_YEAR) %>% 
    mutate(Rate = str_to_title(str_replace(Rate, "^([^_]*_)([^_]*_)", "PER "))) %>% 
    group_by(Rate) %>% 
    mutate(rank = min_rank(desc(casualties))) %>% 
    filter(rank <= 7) %>% 
    arrange(rank)

ggplot(data = casualties_by_type_2, mapping = aes(x = str_to_title(EVTYPE), y = casualties)) + 
    facet_wrap(facets = vars(Rate), ncol = 1, scales = "free", labeller = label_both) + 
    geom_col(mapping = aes(fill = Rate), color = "black") + 
    geom_text(mapping = aes(label = str_c(" ", format(round(casualties, 1), nsmall = 1), " "), hjust = "left")) + 
    geom_blank(mapping = aes(y = 1.05 * casualties)) + 
    coord_flip() + 
    guides(fill = "none", color = "none") + 
    scale_fill_manual(values = c("slateblue", "forestgreen")) + 
    labs(x = "Weather Event Type", 
         y = "Average Number of Casualties", 
         title = "Top Weather Event Types by Average Casualties Across US", 
         subtitle = "Tsunami has highest average casualties per event while Tornado has highest per year\nExcessive Heat among highest by both measures") + 
    theme(axis.text.y = element_text(size = 11))
```

<img src="../figures/graph-casualties-by-type-1.png" style="display: block; margin: auto;" />

First, we see that by each measure, there is a substantial gap between the greatest measurement and the second greatest measurement. On a per event basis, tsunamis are reported to have the greatest casualty rate with about 8.1 casualties per individual event, while on a per year basis, tornadoes are reported to have the greatest casualty rate, with about 1313.1 casualties per year. Interestingly, neither event type is included among the seven greatest casualty rates by the other measurement. Both heat events and excessive heat events appear among the greatest casualty rates by both measures. This suggests that in terms of public health effects, heat waves, tornadoes, and tsunamis have some of the greatest impacts. Tsunamis are a particularly interesting result, given that much of the United States does not experience tsunamis. We'll discuss this result in a little more detail later in the report.

Now, we'll move on to economic impacts. We'll repeat the methodology used for public health impacts when finding economic impacts. First, we calculate the average total damage per individual occurrence of each type of weather event. Then, we calculate the average total damage per year, using the number of years in the filtered data.


```r
damage_by_type <- stormdata %>%
    group_by(EVTYPE) %>%
    summarize(AVG_DMG_EVENT = mean(DMG_TOTAL, na.rm = TRUE),
              AVG_DMG_YEAR = sum(DMG_TOTAL, na.rm = TRUE) / num_years)
```

Next, we split the data into two groups, one for each type of measurement. We rank the weather event types by each measurement within each group, and filter to retain only the top seven weather event types by each measurement. The resulting calculations are then shown in the following paneled bar plot.


```r
damage_by_type_2 <- damage_by_type %>% 
    gather(key = "Rate", value = "damage", AVG_DMG_EVENT, AVG_DMG_YEAR) %>% 
    mutate(Rate = str_to_title(str_replace(Rate, "^([^_]*_)([^_]*_)", "PER "))) %>% 
    group_by(Rate) %>% 
    mutate(rank = min_rank(desc(damage))) %>% 
    filter(rank <= 7)

ggplot(data = damage_by_type_2, mapping = aes(x = str_to_title(EVTYPE), y = damage / 1e6)) + 
    facet_wrap(facets = vars(Rate), ncol = 1, scales = "free", labeller = label_both) + 
    geom_col(mapping = aes(fill = Rate), color = "black") + 
    geom_text(mapping = aes(label = str_c(" ", format(round(damage / 1e6, 1), nsmall = 1), " "), hjust = "left")) + 
    geom_blank(mapping = aes(y = 1.05 * damage / 1e6)) + 
    coord_flip() + 
    guides(fill = "none") + 
    scale_fill_manual(values = c("darkorange", "midnightblue")) + 
    labs(x = "Weather Event Type", 
         y = "Average Total Damage (US$, Millions)", 
         title = "Top Weather Event Types by Average Total Damage Across US", 
         subtitle = "Hurricanes and Typhoons have highest average damage both per event and per year\nStorm Tide has second highest in both") + 
    theme(axis.text.y = element_text(size = 11))
```

<img src="../figures/graph-damage-by-type-1.png" style="display: block; margin: auto;" />

We note that in terms of total damage, as with casualties, there is a significant gap between the greatest damage rate and the second greatest damage rate. Measured both per individual event and per year, hurricanes and typhoons (different names for the same phenomenon) have the greatest damage rates with about 307.0 million US dollars per event and about 4782.8 million US dollars per year. Also measured both per individual event and per year, storm tide (also known as storm surge) has the second greatest damage rate. Measured per individual event, tropical storms, which are weaker versions of hurricanes, have the third greatest damage rate, while measured per year, floods, which are often caused by hurricanes, have the third greatest damage rate. This suggests that in terms of economic effects, hurricanes, storm tides, floods, and tropical storms have the greatest impacts. It's very interesting to see that hurricanes or events somehow related to hurricanes are associated with the three greatest sources of economic effects in both measures here.

## Further Notes

Our initial questions sought to identify types of weather events with the greatest impacts in terms of public health and economic effects separately. Having answered those, we can also take note of types of weather events that had significant impacts on both public health and economic effects. Hurricanes appeared among the most impactful weather events in average damage per year, average damage per individual event, and average casualties per individual event. Meanwhile, tornadoes, floods, and flash floods all appeared among the most impactful weather events in average damage per year and average casualties per year. Also of note is that tsunamis appeared among the most impactful weather events in average damage per individual event and average casualties per individual event.

Earlier, we mentioned that it was interesting to see tsunamis be reported with the greatest number of casualties per individual event among all types of weather events reported in this data set. The reader likely noticed that all of our measures of public health and economic impacts were averages, and averages are susceptible to significant influence by outliers. This is the case with tsunamis in this data set. In the data set, only 20 tsunami events are reported, which supports the idea that the United States is rarely affected by tsunamis. One tsunami event in the data set was responsible for nearly all of the reported casualties and damage from tsunamis in the data. The event in question did not affect the mainland United States; instead it affected the US territory American Samoa, an island territory in the southern Pacific Ocean. While it makes sense that a tsunami would have much greater impact on a small island than it would on a large land mass, it also verifies that the data set's information on tsunami impacts are influenced by a strong outlier.

In response to this insight, the reader might wonder why averages were used as measurements instead of something more robust to outliers, like medians. Medians were explored for use. However, in the case of casualties per individual event, it was found that the distribution of casualties for nearly every type of weather event was heavily skewed, which resulted in the median number of casualties being zero or one for almost every type of weather event. In the context of our questions, seeking out the most impactful types of weather events, reporting that almost every type of weather event had a median number of casualties per individual event of zero or one did not seem to be very informative. Further, most of the types of weather events have significant outliers of some kind, and so it seems plausible that most types of events are similarly affected by their own outliers. As such, averages were used for reporting casualties per individual event; averages were then used with all other measures for the sake of consistency.

## Session Information

For reproducibility, we report the `R` session information for this report below.


```r
devtools::session_info()
```

```
## - Session info ----------------------------------------------------------
##  setting  value                       
##  version  R version 3.5.1 (2018-07-02)
##  os       Windows 10 x64              
##  system   x86_64, mingw32             
##  ui       RTerm                       
##  language (EN)                        
##  collate  English_United States.1252  
##  ctype    English_United States.1252  
##  tz       America/Chicago             
##  date     2018-12-09                  
## 
## - Packages --------------------------------------------------------------
##  package     * version date       lib source        
##  assertthat    0.2.0   2017-04-11 [1] CRAN (R 3.5.1)
##  backports     1.1.2   2017-12-13 [1] CRAN (R 3.5.0)
##  base64enc     0.1-3   2015-07-28 [1] CRAN (R 3.5.0)
##  bindr         0.1.1   2018-03-13 [1] CRAN (R 3.5.1)
##  bindrcpp    * 0.2.2   2018-03-29 [1] CRAN (R 3.5.1)
##  callr         3.0.0   2018-08-24 [1] CRAN (R 3.5.1)
##  cli           1.0.1   2018-09-25 [1] CRAN (R 3.5.1)
##  colorspace    1.3-2   2016-12-14 [1] CRAN (R 3.5.1)
##  crayon        1.3.4   2017-09-16 [1] CRAN (R 3.5.1)
##  debugme       1.1.0   2017-10-22 [1] CRAN (R 3.5.1)
##  desc          1.2.0   2018-05-01 [1] CRAN (R 3.5.1)
##  devtools      2.0.1   2018-10-26 [1] CRAN (R 3.5.1)
##  digest        0.6.18  2018-10-10 [1] CRAN (R 3.5.1)
##  dplyr       * 0.7.7   2018-10-16 [1] CRAN (R 3.5.1)
##  evaluate      0.12    2018-10-09 [1] CRAN (R 3.5.1)
##  fs            1.2.6   2018-08-23 [1] CRAN (R 3.5.1)
##  ggplot2     * 3.1.0   2018-10-25 [1] CRAN (R 3.5.1)
##  glue          1.3.0   2018-07-17 [1] CRAN (R 3.5.1)
##  gtable        0.2.0   2016-02-26 [1] CRAN (R 3.5.1)
##  hms           0.4.2   2018-03-10 [1] CRAN (R 3.5.1)
##  htmltools     0.3.6   2017-04-28 [1] CRAN (R 3.5.1)
##  knitr         1.20    2018-02-20 [1] CRAN (R 3.5.1)
##  labeling      0.3     2014-08-23 [1] CRAN (R 3.5.0)
##  lazyeval      0.2.1   2017-10-29 [1] CRAN (R 3.5.1)
##  lubridate   * 1.7.4   2018-04-11 [1] CRAN (R 3.5.1)
##  magrittr      1.5     2014-11-22 [1] CRAN (R 3.5.1)
##  memoise       1.1.0   2017-04-21 [1] CRAN (R 3.5.1)
##  munsell       0.5.0   2018-06-12 [1] CRAN (R 3.5.1)
##  pillar        1.3.0   2018-07-14 [1] CRAN (R 3.5.1)
##  pkgbuild      1.0.2   2018-10-16 [1] CRAN (R 3.5.1)
##  pkgconfig     2.0.2   2018-08-16 [1] CRAN (R 3.5.1)
##  pkgload       1.0.2   2018-10-29 [1] CRAN (R 3.5.1)
##  plyr          1.8.4   2016-06-08 [1] CRAN (R 3.5.1)
##  prettyunits   1.0.2   2015-07-13 [1] CRAN (R 3.5.1)
##  processx      3.2.0   2018-08-16 [1] CRAN (R 3.5.1)
##  ps            1.2.1   2018-11-06 [1] CRAN (R 3.5.1)
##  purrr         0.2.5   2018-05-29 [1] CRAN (R 3.5.1)
##  R6            2.3.0   2018-10-04 [1] CRAN (R 3.5.1)
##  Rcpp          0.12.19 2018-10-01 [1] CRAN (R 3.5.1)
##  readr       * 1.1.1   2017-05-16 [1] CRAN (R 3.5.1)
##  remotes       2.0.2   2018-10-30 [1] CRAN (R 3.5.1)
##  rlang         0.3.0.1 2018-10-25 [1] CRAN (R 3.5.1)
##  rmarkdown     1.10    2018-06-11 [1] CRAN (R 3.5.1)
##  rprojroot     1.3-2   2018-01-03 [1] CRAN (R 3.5.1)
##  scales        1.0.0   2018-08-09 [1] CRAN (R 3.5.1)
##  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 3.5.1)
##  stringi       1.2.4   2018-07-20 [1] CRAN (R 3.5.1)
##  stringr     * 1.3.1   2018-05-10 [1] CRAN (R 3.5.1)
##  testthat      2.0.1   2018-10-13 [1] CRAN (R 3.5.1)
##  tibble        1.4.2   2018-01-22 [1] CRAN (R 3.5.1)
##  tidyr       * 0.8.2   2018-10-28 [1] CRAN (R 3.5.1)
##  tidyselect    0.2.5   2018-10-11 [1] CRAN (R 3.5.1)
##  usethis       1.4.0   2018-08-14 [1] CRAN (R 3.5.1)
##  withr         2.1.2   2018-03-15 [1] CRAN (R 3.5.1)
##  yaml          2.2.0   2018-07-25 [1] CRAN (R 3.5.1)
## 
## [1] D:/Programs/R/R-3.5.1/library
```
