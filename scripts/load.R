# This function loads the variable names from the 'features.txt' file.
#
# The return is a data set with the following columns:
#   - index: the variable index
#   - name: the variable name

loadVariableNames <- function(datasetDir = "data/UCI HAR Dataset") {
    
    file <- paste0(datasetDir, "/features.txt")
    
    variableNames <- read.table(file, col.names = c("index", "name"))
    
    variableNames
}

# This function loads the activities names from the 'activity_labels.txt' file
#
# The return is a data set with the following columns:
#   - id: the activity id
#   - name: the activity name or label

loadActivityNames <- function(datasetDir = "data/UCI HAR Dataset") {
    
    file <- paste0(datasetDir, "/activity_labels.txt")
    
    activityNames <- read.table(file, col.names = c("id", "name"))
    
    activityNames
}

# This function validates the group: 'train' or 'test'. If not valid, it halts
# the execution of the script with an error.

validateGroup <- function(group) {
    
    if (group != "train" & group != "test") {
        stop("Group must be either 'train' or 'test'")
    }
}

# This function loads the subject data set from the 'train' or 'test' groups and
# returns it as a tibble.
#
# The return is a data set with the following columns:
#   - Subject: the subject id

loadSubjectDataSet <- function(group, datasetDir = "data/UCI HAR Dataset") {
    
    validateGroup(group)
    
    file <- paste0(datasetDir, "/", group, "/subject_", group, ".txt")
    data <- read.table(file, col.names = c("subject"))
    
    tbl_df(data)
}

# This function loads the activity data set from the 'train' or 'test' groups,
# converts it into a factor with appropriate names and returns it as a tibble.
#
# The return is a data set with the following columns:
#   - Activity: the activity as a factor with appropriate names

loadActivityDataSet <- function(group, datasetDir = "data/UCI HAR Dataset") {
    
    validateGroup(group)
    
    file <- paste0(datasetDir, "/", group, "/y_", group, ".txt")
    data <- read.table(file, col.names = c("activity"))
    
    activityNames <- loadActivityNames(datasetDir)
    
    data$activity <- factor(data$activity, levels = activityNames$id, labels = activityNames$name)
    
    tbl_df(data)
}

# This function loads the measures data set from the 'train' or 'test' groups
# and returns it as a tibble.
#
# The return is a data set with all the measured variables.

loadMeasuresDataSet <- function(group, datasetDir = "data/UCI HAR Dataset") {
    
    validateGroup(group)
    
    variableNames <- loadVariableNames(datasetDir)
    
    columnNames <- variableNames$name %>%
        gsub(pattern = "[^a-zA-Z0-9]+", replacement = "_") %>%
        gsub(pattern = "^_|_$", replacement = "")
    
    file <- paste0(datasetDir, "/", group, "/X_", group, ".txt")
    data <- read.table(file, col.names = columnNames)
    
    tbl_df(data)
}

# This function loads the subject data set, the activity data set and the
# measures data set of a specific group, train or test, and merge everything
# together into a single data set.
#
# The return is a complete data set with all variables merged.

loadCompleteDataSet <- function(group, datasetDir = "data/UCI HAR Dataset") {
    
    validateGroup(group)
    
    data <- bind_cols(
        loadSubjectDataSet(group, datasetDir),
        loadActivityDataSet(group, datasetDir),
        loadMeasuresDataSet(group, datasetDir)
    )
    
    data
}

# This function loads the complete train and test data sets, merging them
# into an unique data set containing the whole data. It also creates an
# extra column to differentiate the train observations from the test
# observations.

loadMergedDataSet <- function(datasetDir = "data/UCI HAR Dataset") {
    
    trainDataSet <- loadCompleteDataSet("train", datasetDir)
    trainDataSet <- mutate(trainDataSet, group = 1)
    
    testDataSet <- loadCompleteDataSet("test", datasetDir)
    testDataSet <- mutate(testDataSet, group = 2)
    
    data <- bind_rows(trainDataSet, testDataSet) %>%
        mutate(group = factor(group, levels = c(1, 2), labels = c("TRAIN", "TEST")))
    
    data
}