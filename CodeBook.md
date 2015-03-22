### Codebook for Getting and Cleaning Data Course Programming Assignment
##### Due 03/22/2015

####  Summary of Assignment
This is the programming assignment for Getting and Cleaning Data which creates an R script called run_analysis.R that prepares and analyzes a tidy data set created from two subsets of the original smartphone data set.  See README file for more information.
Code is located in "run_analysis_R.R" file

### Data
The data set for this assignment was downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
Files were stored in a programming folder for use with this course.  
setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3")  

#### The data set had a one main folder **UCI HAR Dataset** with two subfolders containing train and test data sets
**UCI HAR Dataset**  

1.  **test**  
    *Inertial Signals Folder   < **This folder was not needed for project** >  
    *subject_test.txt            < **File with subject numbers for data set** >  
    *X_test.txt                   < **File with data set** >  
    *y_test.txt                   < **File with activities numbers for data set** >  
2. **train**  
       *Inertial Signals Folder   < **This folder was not needed for project**>  
       *subject_train.txt                 < **File with subject numbers for data set**>  
       *X_train.txt                      < **File with data set**>  
       *y_train.txt                      < **File with activities numbers for data set**>  
     
3. **Other files:** 
   *activity_labels.txt     < **File with activitiy lables associated with data set numbers**>    
   *features_info.txt       < **File describing feature set variables**>  
   *features.txt            < **File with features set variable names**>  
   *README.txt              < **File describing dataset**>  
  

###  Data Assembly and Cleaning
  
#### Variables
#####1.**Data**
  *xtest <2947X561> dataframe containing test dataset values    
  *ytest <2947X1> dataframe containing test activity numbers  
  *testsub <2947X1> dataframe containing test subject numbers    
  *xtrain <2947X561> dataframe containing train dataset values    
  *ytrain <2947X1> dataframe containing test activity numbers    
  *trainsub <2947X1> dataframe containing train subject numbers   
  *features <561x2> factor contaning features names to add column names to xtest and xtrain data sets    *testdb <2947X564> dataframe merging testx/testy/testsub/subset(adds column of "test")       
  *traindb <7252X564> dataframe merging testx/testy/testsub/subset(adds column of "train")     
  *totaldb <10299x564> dataframe merging testdb and traindb  
  *meanSTDdb <10299X88> dataframe subset of totaldb containing mean and std calculations  
  *subACT <variable dimensions>  Loop dataframe to subset totaldb based on subject and activity  
  *tidydb <180X88> dataframe containing final tidy data mearging meanSTDdb with subject# and activity
  
#####2.**Values**
  *activity <1:6> Holds cleaned activity names to substitute for activity numbers in data sets     
  *activityWords <1:10299> Holds activity words to substitute for activity numbers in merged data set     
  *featuresC <1:88> Holds feature names containg means or std calculations  
  *namesdb <1:564>  Holds feature names    
  *rowID  <1:180> Loop variable that counts total subject observations    
  *subset < Variabe that containg either "test" or "train" to add to the testdb or traindb, respectively.>    
  *i  <1:30> loop variable that counts subjects  
  *j  <1:6> Loop variable that counts activites  
  
#### Code

**# Load in Feature Set Names for Dataset**
```
setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3/UCI HAR Dataset")
features=read.table("features.txt")
```
**# Load Test Tables and Check Data**
```
setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3/UCI HAR Dataset/test")
ytest=read.table("y_test.txt", col.names="activity")
xtest=read.table("x_test.txt",col.names = features[,2])
testsub=read.table("subject_test.txt",col.names="subject")
```
**# Check Data**
```
str(ytest)
str(xtest)
str(testsub)
```
**# Load Train Tables and check data**
```
setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3/UCI HAR Dataset/train")
ytrain=read.table("y_train.txt",col.names="activity")
xtrain=read.table("x_train.txt",col.names = features[,2])
trainsub=read.table("subject_train.txt",col.names="subject")
```
**#  Check data**
```
str(ytrain)
str(xtrain)
str(trainsub)
```
**#  Merge Test and Train Datasets Combine xtest/ytest/subject_test with an added column to ID test or train data**
```
subset=rep("test",nrow(testsub))
testdb=cbind(xtest,ytest,testsub,subset)
```
**#  Combine xtest/ytest/subject_test with an added column to ID test or train data**
```
subset= rep("train",nrow(trainsub))
traindb=cbind(xtrain,ytrain,trainsub,subset)
```
**# Combine testdb/traindb and check data**
```
totaldb = rbind(traindb,testdb)
Check Data
sum(is.na(totaldb))
str(totaldb)
head(totaldb)
```
**# Subset combined database based on Mean and Standard Deviation Calculations**  
**# Note: the subseting was done base on "mean" and "std" but ignoring case to obtain all caluclations with "mean" and "std"**
```
namesdb= names(totaldb)
meanSTDdb=totaldb[,c(563,562,grep("mean",namesdb, ignore.case=T),grep("std",namesdb,ignore.case=T))]
```
**# Substitute activity labels for numbers in Activity Column**  
**# Set up activity table with more concise wording**
```
activity=c("walking","walking_up","walking_down","sitting","standing","laying")
activityWords=meanSTDdb$activity
for (i in 1:6){
    activityWords= sub(i,activity[i],activityWords)
}
```
**# Substitute words for numbers in activity column**
```
meanSTDdb$activity = activityWords
```
**# Create tidy subset database with averages of columns according to Subject and Activity**  
``` 
tidydb=data.frame(matrix(NA, nrow=180, ncol=88))   #create dataframe to hold new one  
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
**# Modify Column Names to Indicate Change in Calculations to Average**  
```
featuresC=as.character(names(meanSTDdb))  
featuresC[3:88] <- paste("Avg", colnames(meanSTDdb[3:88]), sep = "_")  
colnames(tidydb)= featuresC  
```
**# Modify Activity Column to a Factor**
```
tidydb$activity=as.factor(tidydb$activity)
```
**# Final Check of New Tidy Database**
```
head(tidydb)
tail(tidydb)
sum(is.na(tidydb))
```
**# Write file as .TXT for upload to GitHub**
```
setwd("~/Documents/Magic Briefcase/Computer/Data_science_Track1/Data_Cleaning_3")
write.table(tidydb, "tidydb.txt",row.name=FALSE)
```
 
 
###  Tidy Data Set

#### The final data set contining tidy is stored in tidydb<180X88> and was transformed and cleaned as follows:
```
str(tidydb) 
data.frame':	180 obs. of  88 variables:
$ subject                                 : int  1 1 1 1 1 1 2 2 2 2 ...
$ activity                                : Factor w/ 6 levels "laying","sitting",..: 4 6 5 2 3 1 4 
$ Avg_tBodyAcc.mean...X                   : num  0.277 0.255 0.289 0.261 0.279 ...
```
1.  Variables were limited to "mean" and "std" calculations
2.  Mean and STD variables were averaged according to subject number and activity
3.  Variable names were modified to include "Avg_" as prefix to distinguish from original variable 
4.  Observation were ordered according to subject and then activity to show all activies for each subject 
5.  Subject numbers were appended to front of Tidy Data Set in column 1
6.  Activities were appended to front of Tidy Data Set in column 2
7.  Activity names were shortend to make more readable
8.  All data were checked for missing and erroneous entry

### Final Tidy Data Set Summary
```
summary(tidydb[1,1:5])
    subject          activity Avg_tBodyAcc.mean...X Avg_tBodyAcc.mean...Y Avg_tBodyAcc.mean...Z
 Min.   :1   laying      :0   Min.   :0.2773        Min.   :-0.01738      Min.   :-0.1111      
 1st Qu.:1   sitting     :0   1st Qu.:0.2773        1st Qu.:-0.01738      1st Qu.:-0.1111      
 Median :1   standing    :0   Median :0.2773        Median :-0.01738      Median :-0.1111      
 Mean   :1   walking     :1   Mean   :0.2773        Mean   :-0.01738      Mean   :-0.1111      
 3rd Qu.:1   walking_down:0   3rd Qu.:0.2773        3rd Qu.:-0.01738      3rd Qu.:-0.1111      
 Max.   :1   walking_up  :0   Max.   :0.2773        Max.   :-0.01738      Max.   :-0.1111      
```
```
head(tidydb[1:6,1:5])
  subject     activity Avg_tBodyAcc.mean...X Avg_tBodyAcc.mean...Y Avg_tBodyAcc.mean...Z
1       1      walking             0.2773308          -0.017383819            -0.1111481
2       1   walking_up             0.2554617          -0.023953149            -0.0973020
3       1 walking_down             0.2891883          -0.009918505            -0.1075662
4       1      sitting             0.2612376          -0.001308288            -0.1045442
5       1     standing             0.2789176          -0.016137590            -0.1106018
6       1       laying             0.2215982          -0.040513953            -0.1132036
```

