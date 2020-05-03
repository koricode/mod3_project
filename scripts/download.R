downloadAndExtractDataset <- function (datadir = "data", dlmethod = "libcurl") {
    
    # Creates the data directory
    
    if (!dir.exists(datadir)) dir.create(datadir)
    
    # Download and unzip the dataset
    
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    file <- "fuci_har_dataset.zip"
    
    download.file(url = url, destfile = file, method = dlmethod)
    
    unzip(file, exdir = datadir)
    
    # Removes the zipped dataset and other variables registered variables
    
    unlink(file)
}