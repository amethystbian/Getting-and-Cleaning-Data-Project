# set the working directory
setwd("C:/Users/jx/Desktop/R assignment/UCI HAR Dataset")

# load the data into R
train_x <- read.table("./train/X_train.txt")
train_y <- read.table("./train/y_train.txt")
train_subject <- read.table("./train/subject_train.txt")
test_x <- read.table("./test/X_test.txt")
test_y <- read.table("./test/y_test.txt")
test_subject <- read.table("./test/subject_test.txt")


# 1. Merges the training and the test sets to create one data set.
# combine tables
trainData <- cbind(train_subject, train_y, train_x)
testData <- cbind(test_subject, test_y, test_x)

# merge train and test data
MergeData <- rbind(trainData, testData)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# get the feature of the data
Feature <- read.table("./features.txt", stringsAsFactors = FALSE)[,2]

# add feature into the data
FeatureIndex <- grep(("mean\\(\\)|std\\(\\)"), Feature)
DATA <- MergeData[, c(1, 2, FeatureIndex+2)]
colnames(DATA) <- c("subject", "activity", Feature[FeatureIndex])


# 3. Uses descriptive activity names to name the activities in the data set
ActivityName <- read.table("./activity_labels.txt")
DATA$activity <- factor(DATA$activity, levels = ActivityName[,1], labels = ActivityName[,2])


# 4. Appropriately labels the data set with descriptive variable names.
names(DATA) <- gsub("\\()", "", names(DATA))
names(DATA) <- gsub("^t", "time", names(DATA))
names(DATA) <- gsub("^f", "frequence", names(DATA))
names(DATA) <- gsub("-mean", "Mean", names(DATA))
names(DATA) <- gsub("-std", "Std", names(DATA))


# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
install.packages("plyr")
library(plyr)
tidyData<-aggregate(. ~subject + activity, DATA, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]
# save the data into a new table which is clean and tidy
write.table(tidyData, file = "tidyData.txt",row.name=FALSE)