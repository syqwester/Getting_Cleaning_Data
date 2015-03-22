##  The data linked to from the course website represent data collected from the accelerometers from 
#the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
  ##  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
  ##  Here are the data for the project: 
  ##    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

##  You should create one R script called run_analysis.R that does the following. 
##  Merges the training and the test sets to create one data set.
##  Extracts only the measurements on the mean and standard deviation 
    ## for each measurement. 
##  Uses descriptive activity names to name the activities in the data set
##  Appropriately labels the data set with descriptive variable names. 
##  From the data set in step 4, creates a second, independent tidy data set 
##  with the average of each variable for each activity and each subject.

setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3")
##  Source: ( https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
##  Files downloaded from link and stored unzipped in Data_Cleaning_3 folder.


## Obtain Train and Test Datasets from UCI HAR Dataset

# Load in Feature Set Names for Dataset
setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3/UCI HAR Dataset")
features=read.table("features.txt")

# Load Test Tables and Check Data
setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3/UCI HAR Dataset/test")
ytest=read.table("y_test.txt")
xtest=read.table("x_test.txt")
testsub=read.table("subject_test.txt",)
##str(ytest)
##str(xtest)
##str(testsub)

# Load Train Tables and check data
setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3/UCI HAR Dataset/train")
ytrain=read.table("y_train.txt")
xtrain=read.table("x_train.txt")
trainsub=read.table("subject_train.txt")
##  str(ytrain)
##  str(xtrain)
##  str(trainsub)

##  Add column names for GitHub version
"y_train.txt"col.names="activity"
"x_train.txt"col.names = features[,2]
"subject_train.txt"col.names="subject"
"y_train.txt"col.names="activity"
"x_train.txt"col.names = features[,2]
"subject_train.txt"col.names="subject"

##  Merge Test and Train Datasets
##  Combine xtest/ytest/subject_test with an added column to ID test or train data

subset=rep("test",nrow(testsub))
testdb=cbind(xtest,ytest,testsub,subset)

##  Combine xtest/ytest/subject_test with an added column to ID test or train data
subset= rep("train",nrow(trainsub))
traindb=cbind(xtrain,ytrain,trainsub,subset)

# Combine testdb/traindb and check data
totaldb = rbind(traindb,testdb)
##  sum(is.na(totaldb))
##  str(totaldb)
##  head(totaldb)

## Subset combined database based on Mean and Standard Deviation Calculations
namesdb= names(totaldb)
meanSTDdb=totaldb[,c(563,562,grep("mean",namesdb, ignore.case=T),grep("std",namesdb,ignore.case=T))]

## Substitute activity labels for numbers in Activity Column
## Set up activity table with more concise wording

activity=c("walking","walking_up","walking_down","sitting","standing","laying")
activityWords=meanSTDdb$activity

for (i in 1:6){
    activityWords= sub(i,activity[i],activityWords)
}

## Substitute words for numbers in activity column
meanSTDdb$activity = activityWords

## Create tidy subset database with averages of columns
  ##  according to Subject and Activity

tidydb=data.frame(matrix(NA, nrow=180, ncol=88))  # create dataframe to hold new one
rowID=0
for(i in 1:30){
    for(j in 1:6){
        rowID= rowID + 1
        tidydb[rowID,1]= i   # Adds Subject#
        tidydb[rowID,2]= activity[j]   # Adds Activity
        subAct = meanSTDdb[meanSTDdb$subject==i & meanSTDdb$activity==activity[j],3:88]
        tidydb[rowID,3:88]= colMeans(subAct)   #Column means for Subject/Activity
    }
}
 

## Modify Column Names to Indicate Change in Calculations to Average
featuresC=as.character(names(meanSTDdb))
featuresC[3:88] <- paste("Avg", colnames(meanSTDdb[3:88]), sep = "_")
colnames(tidydb)= featuresC

##  Modify Activity Column to a Factor
tidydb$activity=as.factor(tidydb$activity)

##  Final Check of New Tidy Database

##  head(tidydb)
##  tail(tidydb)
##  sum(is.na(tidydb))

###  Write file as .TXT for upload to GIThub

setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3")
write.table(tidydb, "tidydb.txt",row.name=FALSE)

