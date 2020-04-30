(function () {
    # Creates the data directory
    
    if (!dir.exists("data")) dir.create("data")
    
    # Download and unzip the dataset
    
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    file <- "data/fuci_har_dataset.zip"
    
    download.file(url = url, destfile = file, method = "libcurl")
    
    unzip(file, exdir = "data")
    
    # Removes the zipped dataset and other variables registered variables
    
    unlink(file)
})()