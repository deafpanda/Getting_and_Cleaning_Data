--- 
title: "Tidydata - Human Activity Recognition Using Smartphones Data Set" 
author: "Megan A Graye"
date: "September 26, 2015"
output: html_document
---

# FILENAME: README.MD
As required by course project deliverables specification.

## REPOSITORY CONTENT
1. README.MD
This document provided information about repository content, dataset usage license,
project deliverables, abstract regarding data acquisition and characterization.

2. CODEBOOK.MD


## License:========
Use of this dataset in publications must be acknowledged by
referencing the following publication [1]

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L.
Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass
Hardware-Friendly Support Vector Machine. International Workshop of Ambient
Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

## Required Project Deliverables
1. a tidy data set as described below
2. a link to a Github repository with  your script for performing the analysis
3. a code book that describes the variables, the data, and any transformations or work
that you performed to clean up the data called CodeBook.md.
4. You should also include a README.md in the repo with your scripts.
This repo explains how all of the scripts work and how they are connected.


## Abstract
The data used in this analysis is based on the “Human activity
recognition using smartphones” data set available from the UCL Machine Learning
Repository [2].  The set contains data derived from 3-axial linear acceleration
and 3-axial angular velocity sampled at 50Hz from a Samsung Galaxy S II. These
signals were preprocessed using various filters and other methods to reduce
noise and to separate low- and high-frequency components.

From this data a set of 17 individual signals was extracted by separating e.g.
accelerations due to gravity from those due to body motion, separating
acceleration magnitude into its individual axis-aligned components and so on.
The final feature variables were calculated from both the time and frequency
domain of these signals. They include too large a range to cover entirely here,
but examples include variables related to the spread and centre of each signal,
its entropy, skewness and kurtosis in frequency space and many more.

All data was recorded while subjects (age 19-48) performed one of six activities
and labelled accordingly: lying, sitting, standing, walking, walking down stairs
and walking up stairs.

Key reference for "Readable column" content is the file: featuresinfo.txt found 
in the ./data/

## Objective
The problem to be solved in our analysis is the transformation of
the raw data into a tidy dataset which complies with tidydata principles as
asserted in Hadley's article on Tidy data [3].




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



## Bibliography
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra
and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a
Multiclass Hardware-Friendly Support Vector Machine. International Workshop of
Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

[2]<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>
UCI Data set: Human Activity Recognition Using Smartphones

[3]<http://vita.had.co.nz/papers/tidy-data.html> The Journal of Statistical
Software, vol. 59, 2014. Hadley Wickam (1998).

. ## END OF DOCUMENT