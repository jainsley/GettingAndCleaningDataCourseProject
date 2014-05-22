#Set working directory
#setwd("C:/Users/jainsl01/Copy/Courses/CourseraDataScience/Course3_CleaningData/courseProject")
setwd("~/Copy/Courses/CourseraDataScience/Course3_CleaningData/courseProject")

#Load libraries
library(stringr)
library(plyr)
library(reshape2)

#######################################
#    Read in activity and features
#######################################

#Read in activity labels
activity_labels <- read.table("./data/activity_labels.txt", header= FALSE)
colnames(activity_labels) <- c("label", "activity")

#Read in features
features <- read.table("./data/features.txt", header = FALSE, stringsAsFactors = FALSE)
colnames(features) <- c("colNum", "feature")

#######################################
#    Test data set
#######################################

#Read in test data set
testX <- read.table("./data/test/X_test.txt", header = FALSE)
colnames(testX) <- features$feature

#Subset mean and standard deviation columns
columnsToSelect <- sort(c(grep("mean\\(\\)", colnames(testX)), 
                          grep("std\\(\\)", colnames(testX))))
testX_meanStdDev <- testX[,columnsToSelect]

#Remove punctuation from feature names
colnames(testX_meanStdDev) <- str_replace_all(colnames(testX_meanStdDev), "[[:punct:]]", "")

#Read in test activity label data, replace numbers with descripttestY <- read.table("./data/test/Y_test.txt", header = FALSE)
testY_labels <- testY

for(i in 1:nrow(activity_labels)) {
  testY_labels[,1] <- gsub(pattern=activity_labels[i,1],
                       replacement=activity_labels[i,2],
                       x=testY_labels[,1])
}

#Add activity labels to test data set
testX_meanStdDev$activity <- testY_labels[,1]

#Read in subject information, add to test data set
testSubject <- read.table("./data/test/subject_test.txt", header = FALSE)
testX_meanStdDev$subject <- testSubject[,1]
#######################################
#    Train data set
#######################################

#Read in train data set
trainX <- read.table("./data/train/X_train.txt", header = FALSE)
colnames(trainX) <- features$feature

#Subset mean and standard deviation columns
columnsToSelect <- sort(c(grep("mean\\(\\)", colnames(trainX)), 
                          grep("std\\(\\)", colnames(trainX))))
trainX_meanStdDev <- trainX[,columnsToSelect]

#Remove punctuation from feature names
colnames(trainX_meanStdDev) <- str_replace_all(colnames(trainX_meanStdDev), "[[:punct:]]", "")

#Read in train activity label data, replace numbers with descriptive names
trainY <- read.table("./data/train/Y_train.txt", header = FALSE)
trainY_labels <- trainY

for(i in 1:nrow(activity_labels)) {
  trainY_labels[,1] <- gsub(pattern=activity_labels[i,1],
                           replacement=activity_labels[i,2],
                           x=trainY_labels[,1])
}

#Add activity labels to train data set
trainX_meanStdDev$activity <- trainY_labels[,1]

#Read in subject information, add to train data set
trainSubject <- read.table("./data/train/subject_train.txt", header = FALSE)
trainX_meanStdDev$subject <- trainSubject[,1]

#######################################
#    Merge data sets
#######################################

merged_meanStdDev <- rbind(testX_meanStdDev, trainX_meanStdDev)

#######################################
#    Summarize data sets
#######################################

merged_melt <- melt(merged_meanStdDev, id.vars = c("activity", "subject"))

summary_meanStdDev <- ddply(merged_melt, c("activity", "subject", "variable"), summarize,
                            average = mean(value))

summary_meanStdDev_wide <- dcast(summary_meanStdDev, formula = activity + subject ~ variable)

write.table(summary_meanStdDev_wide, "./data/tidy_data.txt", sep = "\t",
            row.names = FALSE, quote = FALSE)
