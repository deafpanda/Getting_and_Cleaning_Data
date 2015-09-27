##
## You should create one R script called run_analysis.R that does the following. 

## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set with
## the average of each variable for each activity and each subject.

##  Script assumes script directory is the current working directory
## Set working directory
#setwd("./data/UCI HAR Dataset")

## Load requisite libraries
library(data.table)
library(plyr)
library(dplyr)

## Stage merge operation by loading data from disk

## Read metadata files
featureNames <- read.table("./features.txt")
activityLabels <- read.table("./activity_labels.txt", header = FALSE)

## Read TRAIN data
subjectTrain <- read.table("./train/subject_train.txt", header = FALSE)
activityTrain <- read.table("./train/y_train.txt", header = FALSE)
featuresTrain <- read.table("./train/X_train.txt", header = FALSE)

## Read TEST data
subjectTest <- read.table("./test/subject_test.txt", header = FALSE)
activityTest <- read.table("./test/y_test.txt", header = FALSE)
featuresTest <- read.table("./test/X_test.txt", header = FALSE)

## 1. Merges the training and the test sets to create one data set.

## Combine TRAIN and TEST data
subject <- rbind(subjectTrain, subjectTest) 
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

## Remove raw data staging tables - Saves RAM
rm(subjectTrain, subjectTest, activityTrain, activityTest, featuresTrain, featuresTest)

## Acquire the feature column names
colnames(features) <- t(featureNames[2])
colnames(features)

## Assign column names to the activityLabels table
colnames(activityLabels) <- c("ActivityID", "Activity")

## Apply descriptive column names to activity table to ensure effective merge
## operation (further down), while retaining the descriptive ActivityLabels
colnames(activity) <- "ActivityID"
colnames(subject) <- "Subject"

## Combine the datasets: features, activity, subject
CompleteDataSet <- cbind(activity, subject, features)

## Remove raw data staging tables - Saves RAM
rm(features, subject)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## Get columns which reference Activity, Subject, mean or standard deviation
##  Mean = *[m|M]ean* [case insensitive]
## Standard deviation = *Std* [case insensitive]

ColumnNamesofInterest <- grep("Activity|Subject|.*[m|M]ean.*|.*Std.*", colnames(CompleteDataSet), ignore.case=TRUE)
MeanandStdData <- CompleteDataSet[ ,ColumnNamesofInterest]

MeanandStdAverages <- ddply(MeanandStdData, .(ActivityID, Subject), colMeans)

## 3. Uses descriptive activity names to name the activities in the data set
MeanandStdAveragesAct <- merge(MeanandStdAverages, activityLabels, by = "ActivityID")

## Reorder dataset to include descriptive Activity field as beginning column
MSA1 <- as.data.table(MeanandStdAveragesAct %>% select(Activity, everything()))

## 4. Appropriately labels the data set with descriptive variable names.
colnames(MSA1) <- gsub("acc", "Acceleration", colnames(MSA1), ignore.case = TRUE)
colnames(MSA1) <- gsub("^t", "Time", colnames(MSA1), ignore.case = TRUE)
colnames(MSA1) <- gsub("^f", "Frequency", colnames(MSA1), ignore.case = TRUE)
colnames(MSA1) <- gsub("gyro", "Gyroscopic", colnames(MSA1), ignore.case = TRUE)
colnames(MSA1) <- gsub("Mag", "Magnitude", colnames(MSA1), ignore.case = FALSE)
colnames(MSA1) <- gsub("tBody", "TimeBody", colnames(MSA1), ignore.case = FALSE)
colnames(MSA1) <- gsub("BodyBody", "Body", colnames(MSA1), ignore.case = FALSE)


## 5. From the data set in step 4, create a second, independent tidy data set
## with the average of each variable for each activity and each subject.

##  Define the dataset pivot axes
idlabels <- c("Subject", "Activity")
datalabels <- setdiff(colnames(MSA1), idlabels)

## transform table - for each unique combination of subject and activity
##  generate the corresponding values for features
meltdata <- melt(MSA1, id = idlabels, measure.vars = datalabels)

##  Collapse the resulting mesaurement observations into an average for each
## unique combination of subject and activity
tidydata <- dcast(meltdata, Subject + Activity ~ variable, mean)

## Show characteristics of tidydata table
str(tidydata)

## Remove extraneous data objects to preserve RAM
rm(activity, activityLabels, CompleteDataSet, featureNames,
   MeanandStdAverages, MeanandStdData, MeanandStdAveragesAct, MSA1)

## Persist tidydata table to disk in the project root
write.table(tidydata, file = "../../tidydata.txt", row.names = FALSE)


