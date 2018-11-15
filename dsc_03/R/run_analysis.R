# Programmer's Note: code for reading in data stores data files in parallel 
# directory "data"

# load package dplyr for later use in data manipulation
library(dplyr)

# download file
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "../data/UCI HAR Dataset.zip", 
              method = "curl")

# unzip downloaded file
unzip(zipfile = "../data/UCI Har Dataset.zip", 
      exdir = "../data")

# read in files
activity_labels <- read.table(file = "../data/UCI HAR Dataset/activity_labels.txt", 
                              col.names = c("activity_code", "activity_name"), 
                              colClasses = c("integer", "character"), 
                              nrows = 6)
features <- read.table(file = "../data/UCI HAR Dataset/features.txt", 
                       col.names = c("feature_code", "feature_name"), 
                       colClasses = c("integer", "character"), 
                       nrows = 561)
x_train <- read.table(file = "../data/UCI HAR Dataset/train/X_train.txt", 
                      col.names = features$feature_name, 
                      colClasses = rep("numeric", times = 561), 
                      nrows = 7352)
y_train <- read.table(file = "../data/UCI HAR Dataset/train/Y_train.txt", 
                      col.names = "activity_code", 
                      colClasses = "integer", 
                      nrow = 7352)
sub_train <- read.table(file = "../data/UCI HAR Dataset/train/subject_train.txt", 
                        col.names = "subject", 
                        colClasses = "integer", 
                        nrow = 7352)
x_test <- read.table(file = "../data/UCI HAR Dataset/test/X_test.txt", 
                     col.names = features$feature_name, 
                     colClasses = rep("numeric", times = 561), 
                     nrows = 2947)
y_test <- read.table(file = "../data/UCI HAR Dataset/test/Y_test.txt", 
                     col.names = "activity_code", 
                     colClasses = "integer", 
                     nrow = 2947)
sub_test <- read.table(file = "../data/UCI HAR Dataset/test/subject_test.txt", 
                       col.names = "subject", 
                       colClasses = "integer", 
                       nrow = 2947)

# begin dependency on package dplyr

# combine x, y, and subject columns into full training and testing data sets
# note -- build using as_tibble() for speed in later operations
full_train <- as_tibble(cbind(x_train, y_train, sub_train))
full_test <- as_tibble(cbind(x_test, y_test, sub_test))

# use inner_join() to connect activity codes with activity names
# then, use select() to drop the activity code column and move the 
# activity name column to that position
full_train <- inner_join(full_train, activity_labels, by = "activity_code") %>% 
    select(1:561, -activity_code, activity_name, subject)
full_test <- inner_join(full_test, activity_labels, by = "activity_code") %>% 
    select(1:561, -activity_code, activity_name, subject)

# combine training and testing data
full_data <- union(full_train, full_test)

# clean up workspace; component data frames and raw read-ins from data files 
# are no longer necessary
rm(activity_labels, features, full_test, full_train, sub_test, sub_train, 
   x_test, x_train, y_test, y_train)

# reduce data set by extracting columns containing "mean..", columns containing 
# "std..", and columns for activity name and subject
red_data <- full_data %>% 
    select(contains("mean..", ignore.case = TRUE), 
           contains("std..", ignore.case = TRUE), 
           activity_name, 
           subject)

# group data by activity_name and subject
# then calculate mean of all remaining columns, labeling columns using form 
# <new_col_name> = "<old_col_name>_avg"
summ_data <- red_data %>% 
    group_by(activity_name, subject) %>% 
    summarize_all(.funs = funs(avg = "mean"))

# write final data set to file
write.table(x = summ_data, file = "summ_data.txt", row.names = FALSE)
