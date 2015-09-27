---
title: "Codebook: Tidydata - Human Activity Recognition Using Smartphones Data Set" 
author: "Megan A Graye"
date: "September 26, 2015"
output: html_document
---

This document describes the steps to recreate the operations to derive the 
results in this project.


## OBJECTIVE
The problem to be solved in our analysis is the transformation of
the raw data into a tidy dataset which complies with tidydata principles as
asserted in Hadley's article on Tidy data [3].

## ASSUMPTIONS
The raw data has been downloaded and unzipped into the directory data which 
resides directly below the directory where the script run_analysis.R resides.

The working direction is set to the relative path for the raw data associated
with this project as follows:
setwd("./data/UCI HAR Dataset")

## RELEVANT SOFTWARE VERSIONS
###Version of OS and RStudio used in the project:
```{r}
R.version
               _                           
platform       x86_64-pc-linux-gnu         
arch           x86_64                      
os             linux-gnu                   
system         x86_64, linux-gnu           
status                                     
major          3                           
minor          2.2                         
year           2015                        
month          08                          
day            14                          
svn rev        69053                       
language       R                           
version.string R version 3.2.2 (2015-08-14)
nickname       Fire Safety                 
```


###RStudio Version:
```{r}
RStudio.Version()
$mode
[1] "desktop"

$version
[1] ‘0.99.467’
```


### RegExBuddy Version:
4.2.1 - x64 on Windows 8.1
RegexBuddy is a proprietary (non-Free Software) only available for Windows Platform
RegExBuddy is used to derive efficient and effective regular expressions for
Grep operations used to extract and transform field references.


### Raw Dataset version:
Original hosted location for the raw dataset:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>
Raw dataset was retrieved as a zip package from the following URL:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
Additional versioning information indeterminant.





## Libraries (other than Base R)
### * data.table
#### Functions
1. as.data.table - allows for simple column reordering
2. melt - transform table - for each unique combination of subject and activity
  generate the corresponding values for features
3. dcast - Collapse the resulting mesaurement observations into an average for each
 unique combination of subject and activity

### * plyr
#### Functions
1. ddplyr - Obtain mean for all features by unique combination of subject and activity
2. merge - Links activitylabels with features on activityID
3. select - Reorder dataset to include descriptive Activity field as beginning column
4. %>% (Chain operation) -Reorder dataset to include descriptive Activity field as beginning column

***

## DATA CHARACTERISTICS

### Units of Measure

####  Activities

## Data Characteristics Metadata file descriptions are as follows:

### activityLabels
The raw table activityLabels appears to be a list comprised
of two vectors:

1. V1 is an ascending vector of type integer 
2. V2 is a vector of type character; descriptive of the mutually exclusive verbs
in which the subject of the activity was engaged to elicit the measurements found
in the features tables.

```{r}
typeof(activityLabels) 

print(activityLabels)
  V1                 V2
1  1            WALKING
2  2   WALKING_UPSTAIRS
3  3 WALKING_DOWNSTAIRS
4  4            SITTING
5  5           STANDING
6  6             LAYING
```





####  Features
Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 



## Steps of operation


## 1. Merges the training and the test sets to create one data set.

### Read metadata files
Load ./features.txt into datatable
load ./activity_lables.txt into datatable

### Read TRAIN and TEST data
load ./train/subject_train.txt into datatable
load ./train/x_train.txt into datatable
load ./train/y_train.txt into datatable

### Load equivalent test datasets using the same methodology

#### Join test and train data into one datatable per subject, activity and features
rbind test and train tables for subject table
rbind test and train tables for activity table
rbind test and train tables for features table 

#### Perform initial population of features table column labels
take the list of featurenames from second column of ./features.txt and transform the vector
from vertical to horizontal using the t function and assigning the result to the features
table columnnames.

#### Assign column names to the activityLabels table - ActvityID will be the merge ID when combining
Apply descriptive column names to activity table to ensure effective merge
operation (further down), while retaining the descriptive ActivityLabels

#### Combine the datasets
Aggregate the datatables features, activity, subject into a well described aggregate
datatable called CompleteDataSet

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
 Get columns which reference Activity, Subject, mean or standard deviation using
 the base package function grep
  Mean = *[m|M]ean* [case insensitive]
  Standard deviation = *Std* [case insensitive]

```{r}
ColumnNamesofInterest <- grep"Activity|Subject|.*[m|M]ean.*|.*Std.*", colnames(CompleteDataSet), ignore.case=TRUE)
MeanandStdData <- CompleteDataSet[ ,ColumnNamesofInterest]

MeanandStdAverages <- ddply(MeanandStdData, .(ActivityID, Subject), colMeans)
```

## 3. Uses descriptive activity names to name the activities in the data set
MeanandStdAveragesAct <- merge(MeanandStdAverages, activityLabels, by = "ActivityID")

#### Reorder dataset to include descriptive Activity field as beginning column
MSA1 <- as.data.table(MeanandStdAveragesAct %>% select(Activity, everything()))

## 4. Appropriately labels the data set with descriptive variable names.
```{r}
colnames(MSA1) <- gsub("acc", "Acceleration", colnames(MSA1), ignore.case = TRUE)
colnames(MSA1) <- gsub("^t", "Time", colnames(MSA1), ignore.case = TRUE)
colnames(MSA1) <- gsub("^f", "Frequency", colnames(MSA1), ignore.case = TRUE)
colnames(MSA1) <- gsub("gyro", "Gyroscopic", colnames(MSA1), ignore.case = TRUE)
colnames(MSA1) <- gsub("Mag", "Magnitude", colnames(MSA1), ignore.case = FALSE)
colnames(MSA1) <- gsub("tBody", "TimeBody", colnames(MSA1), ignore.case = FALSE)
colnames(MSA1) <- gsub("BodyBody", "Body", colnames(MSA1), ignore.case = FALSE)
```

## 5. From the data set in step 4, create a second, independent tidy data set
with the average of each variable for each activity and each subject.

Define the dataset pivot axes
```{r}
idlabels <- c("Subject", "Activity")
datalabels <- setdiff(colnames(MSA1), idlabels)
```

transform table - for each unique combination of subject and activity
generate the corresponding values for features
```{r}
meltdata <- melt(MSA1, id = idlabels, measure.vars = datalabels)
```

Collapse the resulting measurement observations into an average for each
unique combination of subject and activity

```{r}
tidydata <- dcast(meltdata, Subject + Activity ~ variable, mean)
```

## Persist tidydata table to disk in the project root
write.table(tidydata, file = "../../tidydata.txt", row.names = FALSE)

