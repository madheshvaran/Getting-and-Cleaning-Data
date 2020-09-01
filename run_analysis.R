# To run this R code, it is assumed that there exists the raw data (UCI HAR Dataset) in the working directory
# If not, the data set can be downloaded from the following link:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# This Project is divided into 5 Parts
# Each piece of code's function are represented by the PART Index
# The Parts are not in orderly basis. Please refer to the PART index to know its function
# The function of those parts are explained in README.md



# Packages required for this code are loaded

library(reshape2)
library(data.table) 
# data.table package is chosen instead of base package in order to read and write dataframes faster


 
# PART - 2

activity_labels <- fread("UCI HAR Dataset/activity_labels.txt", col.names = c("Index", "ActivityName"))
features <- fread("UCI HAR Dataset/features.txt", col.names = c("Index", "FeatureName"))
wanted_measurements_index <- grep("([Mm]ean|[Ss]td)\\(\\)", features$FeatureName)
wanted_measurements <- features[wanted_measurements_index, FeatureName]




# PART - 1 and PART - 4

# Extracing Train Dataset
x_train <- fread("UCI HAR Dataset/train/X_train.txt")[, wanted_measurements_index, with = FALSE]
setnames(x_train, colnames(x_train), wanted_measurements)
y_train <- fread("UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
subject_train <- fread("UCI HAR Dataset/train/subject_train.txt", col.names =  "Subject")
train <- cbind(subject_train, y_train, x_train)

# Extracting Test Dataset
x_test <- fread("UCI HAR Dataset/test/X_test.txt")[, wanted_measurements_index, with = FALSE]
setnames(x_test, colnames(x_test), wanted_measurements)
y_test <- fread("UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
subject_test <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
test <- cbind(subject_test, y_test, x_test)

# Merging them together
merged_data <- rbind(train, test)




# PART - 3

merged_data[[2]] <- factor(merged_data[[2]],
                           levels = activity_labels[[1]],
                           labels = activity_labels[[2]])



# PART - 5

final_data <- melt(merged_data, id = c("Subject", "Activity"))
final_data <- dcast(final_data, Subject + Activity ~ variable, fun.aggregate = mean)

fwrite(final_data, "Tidy_Data.txt", quote = FALSE, sep = " ", row.names = FALSE)



