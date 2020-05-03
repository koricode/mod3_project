library(stringr)
library(dplyr)

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
# variable grouped by the subject, the activity and the group

tidy <- data %>%
    select(subject, activity, group,
           contains("_mean_"), ends_with("_mean"),
           contains("_std_"), ends_with("_std"),
           -contains("angle"), -contains("bodybody")) %>%
    group_by(subject, activity, group) %>%
    summarise_all(mean)

# Give better names to variables, transforming all to lower case and giving
# a better name to magnitude related variables

names(tidy) <- names(tidy) %>%
    tolower %>%
    gsub(pattern = "mag_(mean|std)", replacement = "_\\1_magnitude")

# Write resulting data set to CSV file

write.csv(tidy, file = "output/measures.csv")
