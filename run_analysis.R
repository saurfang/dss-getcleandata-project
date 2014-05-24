#### Necessary Library
if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}


#### Download and Unzip Raw Dataset
dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
path <- basename(dataURL)

if(!file.exists(path)){
  download.file(dataURL, path)
}

unzip(path)


#### Load Relevant Dataframe

# Read features table and sanitize their names
features <- read.table("UCI HAR Dataset/features.txt", 
                       col.names = c("colIndex", "colName"), 
                       colClasses = c("integer", "character"),
                       stringsAsFactors = FALSE)
# Convert to valid column names
# Replace multiple dots with single dot
# Trim trailing dot
features$colName <- features$colName %>% 
  make.names %>%
  gsub("\\.+", ".", .) %>%
  gsub("\\.$", "", .)

# Read activity table and convert it to a named vector
activities <- read.table("UCI HAR Dataset/activity_labels.txt",
                         col.names = c("activityCode", "activityName"),
                         colClasses = c("integer", "character"),
                         stringsAsFactors = FALSE)
activities <- structure(activities$activityName, names=activities$activityCode)

#' Read a training/test data.frame
#' @param type "train" or "test"
#' @param root path to "UCI HAR Dataset"
readDF <- function(type = c("train", "test"), root = "UCI HAR Dataset"){
  type = match.arg(type)
  getPath <- function(x) paste0(root, "/", type, "/", x, "_", type, ".txt")
  
  XDF <- read.table(getPath("X"), col.names = features$colName, colClasses = "numeric")
  # Subsitute activity names
  activity <- activities[readLines(getPath("Y"))]
  subject <- as.integer(readLines(getPath("subject")))
  data.frame(XDF, activity, subject, type=type, 
             check.names = FALSE, stringsAsFactors = FALSE)
}

testDF <- readDF("test")
trainDF <- readDF("train")
mergedDF <- rbind_list(testDF, trainDF)


#### Construct First Tidy Dataset
# Find the columns for mean and std
columns <- grep("mean$|mean\\.|std", colnames(mergedDF), value = TRUE)
# Select the above columns with activity
tidyDF <- mergedDF[, c("activity", columns)]
# Write tidyDf to Disk
write.csv(tidyDF, "UCI-HAR-MeanStd-TrainTest-dataset.csv", row.names = FALSE)


#### Construct Second Tidy Dataset
# Group Dataset by Subject and Activity
# Then summarise the dataset by taking average on every column
groupedDF <- mergedDF[, c(columns, "activity", "subject", "type")] %>% 
  group_by(subject, type, activity) %>% 
  summarise_each(funs(mean))
write.csv(groupedDF, "UCI-HAR-MeanStd-TrainTest-Avg-dataset.csv", row.names = FALSE)