# Cousera Getting and Cleaning Data Course Project     
###  Due:  03/22/2015

### Introduction

This is the programming assignment for Getting and Cleaning Data which creates an R script called run_analysis.R that prepares and analyzes a tidy data set created from two subsets of the original smartphone data set(1).


### Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. For more details see reference (1).


### Assignment Details

The data set for this assignment was downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
Files were stored in a programming folder for use with this course.
setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3")

The data set had a one main folder:UCI HAR Dataset
Subfolders included:test & train which contained two data subset.
Other files:  activity_labels.txt
              features_info.txt
              features.txt
              README.txt
              
With the dataset and files listed above the assignment is as follows:

1.  Merge the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation 
    for each measurement. 
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive variable names. 
5.  From the data set in step 4, creates a second, independent tidy data set 
    with the average of each variable for each activity and each subject.
    
### Coding  (See Codebook.md for additional details)

Obtain Train and Test Datasets from UCI HAR Dataset

####1. Loaded in Feature Set Names for Dataset
```
dir=getwd()   #  Load Current dirctory for global use
setwd(paste0(dir,"/UCI HAR Dataset"))    ## Sets directory to UCI HAR Dataset 
features=read.table("features.txt")
```
####2. Loaded Test Tables and Checked for Data Integrity
```
setwd(paste0(dir,"/UCI HAR Dataset/test"))  
ytest=read.table("y_test.txt", col.names="activity")  
xtest=read.table("x_test.txt",col.names = features[,2])  
testsub=read.table("subject_test.txt",col.names="subject")  
str(ytest)  
str(xtest)  
str(testsub)  
```
####3. Loaded in Train Tables and Checked Data Integrity
```
setwd(paste0(dir,"/UCI HAR Dataset/train"))
ytrain=read.table("y_train.txt",col.names="activity")   # Added column names  
xtrain=read.table("x_train.txt",col.names = features[,2]) # Added column names  
trainsub=read.table("subject_train.txt",col.names="subject") # Added col names  
str(ytrain)  
str(xtrain)  
str(trainsub)  
```
####4. Merged Test and Train Datasets
  **1. Combined xtest/ytest/subject_test with an added column to ID test or train data**
```
subset=rep("test",nrow(testsub))    
testdb=cbind(xtest,ytest,testsub,subset)   
```
  **2. Combined xtest/ytest/subject_test with an added column to ID test or train data** 
```
subset= rep("train",nrow(trainsub))    
traindb=cbind(xtrain,ytrain,trainsub,subset)    
```
####5. Combined testdb/traindb and Checked Data Integrity
```
totaldb = rbind(traindb,testdb)  
sum(is.na(totaldb))  
str(totaldb)  
head(totaldb)  
```
####6. Subset Data Sets Combined Based on Mean and Standard Deviation Calculations
```
namesdb= names(totaldb)
meanSTDdb=totaldb[,c(563,562,grep("mean",namesdb,    # Create smaller Data Set ignore.case=T),grep("std",namesdb,ignore.case=T))]
```
####7. Substitute Activity Labels for Numbers in Activity Column & set up Activity Table with more Concise Wording
```
activity=c("walking","walking_up","walking_down","sitting","standing","laying")  
activityWords=meanSTDdb$activity  
for (i in 1:6){                  
    activityWords= sub(i,activity[i],activityWords)  
}
```
####8. Substitute Words for Numbers in Activity Column
`meanSTDdb$activity = activityWords`

####9. Create Tidy Subset Database with Averages of Columns According to Subject and Activity using logical Subsetting
```
tidydb=data.frame(matrix(NA, nrow=180, ncol=88))  # create dataframe to hold new one  
rowID=0  
for(i in 1:30){  
    for(j in 1:6){  
        rowID= rowID + 1  
        tidydb[rowID,1]= i   # Adds Subject   
        tidydb[rowID,2]= activity[j]   # Adds Activity  
        subAct = meanSTDdb[meanSTDdb$subject==i & meanSTDdb$activity==activity[j],3:88]  
        tidydb[rowID,3:88]= colMeans(subAct)   #Column means for Subject/Activity  
    }  
}  
``` 
####10. Modify Column Names to Indicate Change in Calculations to Average by Preceeding Column Name             with "Avg_""
```
featuresC=as.character(names(meanSTDdb))  
featuresC[3:88] <- paste("Avg", colnames(meanSTDdb[3:88]), sep = "_")  
colnames(tidydb)= featuresC  
```
####11. Modify Activity Column to a Factor 
`tidydb$activity=as.factor(tidydb$activity)`

####12. Final Check of New Tidy Database  
```
head(tidydb)  
tail(tidydb)  
sum(is.na(tidydb))  
```
####13. Write file as .TXT for Upload to GitHub
```
setwd(dir)
write.table(tidydb, "tidydb.txt",row.name=FALSE)  
```
####14. References

1.  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  
