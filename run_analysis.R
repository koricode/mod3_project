library(stringr)
library(dplyr)
library(tidyr)

source("scripts/download.R")
source("scripts/load.R")

# Download the data set and extract it inside data directory.
# Try another download method, 'curl' for example, if 'libcurl' doesn't work on your machine.

downloadAndExtractDataset(dlmethod = "libcurl")

# Load the whole data set in memory, including the train and test data sets.
# The loaded data set will contain the subjects, the activities and every measure,
# all merged together on a single data set. Look at the functions inside
# 'scripts/load.R' script file to learn more.

data <- loadMergedDataSet()

# Selects only the necessary information and calculates the average of every
# variable grouped by the subject, the activity and the group. Bring gather 
# all variables into a variable and value column and apply some tranformations
# to the variable name.

tidy <- data %>%
    # Selects only the necessary information
    select(subject, activity, group, contains("mean"), contains("std"), -contains("angle"), -contains("meanFreq")) %>%
    # Calculates the average of every variable grouped by the subject, the activity and the group
    group_by(subject, activity, group) %>%
    summarise_all(mean)

names(tidy) <- names(tidy) %>%
    # Transform the variable names to detect later separate it by domain, source, sensor, type and axis
    tolower %>%
    sub(pattern = "^t", replacement =  "time") %>%
    sub(pattern = "^f", replacement = "frequency") %>%
    gsub(pattern = "(body|gravity)", replacement = "_\\1") %>%
    gsub(pattern = "acc", replacement = "_accelerometer") %>%
    gsub(pattern = "gyro", replacement = "_gyroscope") %>%
    gsub(pattern = "jerk", replacement = "_jerk") %>%
    gsub(pattern = "mag", replacement = "_magnitude")
    
# Write resulting data set to CSV file

write.table(tidy, file = "output/measures.txt", row.names = FALSE)
