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
    select(subject, activity, group,
           contains("_mean_"), ends_with("_mean"),
           contains("_std_"), ends_with("_std"),
           -contains("angle"), -contains("bodybody")) %>%
    # Calculates the average of every variable grouped by the subject, the activity and the group
    group_by(subject, activity, group) %>%
    summarise_all(mean) %>%
    # Gather all measures into a variable and value column
    gather(variable, value, -(subject:group)) %>%
    # Transform the variable names to detect later separate it by domain, source, sensor, type and axis
    mutate(variable = tolower(variable)) %>%
    mutate(variable = sub("^t", "time_", variable)) %>%
    mutate(variable = sub("^f", "frequency_", variable)) %>%
    mutate(variable = sub("(body|gravity)(acc|gyro)", "\\1_\\2", variable)) %>%
    separate(variable, c("domain", "source", "sensor", "type", "axis")) %>%
    # Detects if the observation is a default signal, a jerk signal or a magnitude
    mutate(jerk = grepl("jerk", sensor), magnitude = grepl("mag", sensor)) %>%
    # Removes jerk or mag text from the sensor
    mutate(sensor = gsub("(jerk|mag)", "", sensor))
    
# Write resulting data set to CSV file

write.table(tidy, file = "output/measures.txt", row.names = FALSE)
