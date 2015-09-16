##Set the folder "UCI HAR Dataset" as working directory

#Downloading and reading data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./data.zip")
unzip("./data.zip")
setwd("~/Universidad/Data Science Specialization/3. Getting and Cleaning Data/UCI HAR Dataset")   ## Set as Working directory

#Reading the Train dataset
X_train <- read.table("./train/X_train.txt", quote="\"", comment.char="")
Train_Activities <- read.table("./train/y_train.txt")
Train_Subject <- read.table("./train/subject_train.txt")
Train <- cbind(Train_Subject, Train_Activities, X_train)
rm(list = setdiff(ls(), "Train"))

#Reading the Test dataset
X_test <- read.table("./test/X_test.txt", quote="\"", comment.char="")
Test_Activities <- read.table("./test/y_test.txt")
Test_Subject <- read.table("./test/subject_test.txt")
Test <- cbind(Test_Subject, Test_Activities, X_test)
rm(list = setdiff(ls(), c("Train", "Test")))

#Merging Test and Train datasets
allData <- rbind(Train, Test)

#Reading activity labels and features
activityLabels <- read.table("./activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("./features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation labels
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

#Adding labels
colnames(allData) <- c("subject", "activity", featuresWanted.names)

#Subject and activity into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

#Writing table tidy.txt
library(reshape2)
allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
