# Getting-and-Cleaning-Data-Assignment  

### Purpose of the Repository:  

This repository was created for the peer-graded assignment of **_"Getting And Cleaning Data"_** which is an online course available on _Coursera_.  
As described in the question, _"The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set"_.  

### Details Of The Files (that exist in the repository):

* #### README.md:    
This is the current file you are reading  
* #### run_analysis.R:  
It is the R Code that reads the raw data and writes the final output  
* #### tidy_data.txt:  
It is the final result produced by the code. It contains the data in a tidy format.   
* #### CodeBook.md:  
It is a file containing the description of all variables (i.e., the column names) that are used in the _"tidy_data"_ dataset  

### Purpose of the R Code:  

There are five parts which the _'run_analysis.R'_ should be able to do. They are as follows:  
  
1. Merges the training and the test sets to create one data set.    
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set.  
4. Appropriately labels the data set with descriptive variable names.  
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

### Code Explanations (In Short):  

```
# PART - 2  
  
activity_labels <- fread("UCI HAR Dataset/activity_labels.txt", col.names = c("Index", "ActivityName"))  
features <- fread("UCI HAR Dataset/features.txt", col.names = c("Index", "FeatureName"))  
wanted_measurements_index <- grep("([Mm]ean|[Ss]td)\\(\\)", features$FeatureName)  
wanted_measurements <- features[wanted_measurements_index, FeatureName]  
```  
This code chunk creates objects that Extracts only the measurements on the **mean and standard deviation** for each measurement. (As said in the second part of the qusetion)  

```
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
```

This code chunk does both the first and fourth part of the question. Both _Train_ and _Test_ datasets are combined and the labels of the dataset is given by **setnames()** function. Both the data extracted is merged at the end of the chunk.  

```
# PART - 3

merged_data[[2]] <- factor(merged_data[[2]],
                           levels = activity_labels[[1]],
                           labels = activity_labels[[2]])
```
This code chunk uses descriptive activity names to name the activities in the data set. (As said in third part of the qusetion)  

```
# PART - 5

final_data <- melt(merged_data, id = c("Subject", "Activity"))
final_data <- dcast(final_data, Subject + Activity ~ variable, fun.aggregate = mean)

fwrite(final_data, "Tidy_Data.txt", quote = FALSE, sep = " ", row.names = FALSE)
```
This code chunk creates a tidy data set with the average of each variable for each activity and each subject. (As said in fifth part of the question). By melting the data on the basis of 'Subject' and 'Activity', the code enables to dcast the data on the basis of mean of the 'variable' (acheived by using _fun.aggregate_ attribute).   
