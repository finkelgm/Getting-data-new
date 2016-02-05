#title: "Course project"
library(dplyr)
library(tidyr)

#read test, train ad features data

test <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
train <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
features <- read.table("UCI HAR Dataset/features.txt", quote="\"", comment.char="")

#Merge the training and the test sets to create one data set.

alldata<-rbind(test,train)

#attach names to the set

colnames(alldata)<-features[,2]

#Extracts only the measurements on the mean and standard deviation for each measurement to the dataset exectmeasures

exectmeasurements<-alldata[,grep("std|mean\\(",names(alldata))]

#Import and add subject data
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
exectmeasurements$subject<-rbind(subjecttest,subjecttrain)[[1]]

#import activities and form datase activities
activitytest <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
activitytrain <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
activities<-rbind(activitytest,activitytrain)

#Use descriptive activity names to name the activities in the data frame
#write this data frame to file 
#x is temporary variable with colnames V1 and V2

x<-inner_join(activities,activitylabels)
exectmeasurements$activity<-x$V2
write.table(exectmeasurements,"exectmeasurements.txt",row.name=FALSE)

#create a second, independent tidy data set with the average of each variable for each activity and each subject (name tidy)
#write this data frame to file 
tidy<- exectmeasurements %>% gather(parameter,value,1:66) %>% group_by(activity, parameter, subject) %>% 
    summarise(average=mean(value))  %>% spread(parameter,average)
write.table(tidy,"tidy.txt",row.name=FALSE )  
