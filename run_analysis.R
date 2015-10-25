library(dplyr)
library(reshape2)

# STEPS 1, 3, and 4
# This merges the training and the test sets to create data frame "alldat" using
# column names from features.txt and activity names from activity_labels.txt
features <- read.table("~/DSWD/CourseProject/UCI HAR Dataset/features.txt")
features2 <- as.vector(features$V2)
subject_train <- read.table("~/DSWD/CourseProject/UCI HAR Dataset/train/subject_train.txt", 
                col.names = "subject")
X_train <- read.table("~/DSWD/CourseProject/UCI HAR Dataset/train/X_train.txt",
                col.names = features2)
Y_train <- read.table("~/DSWD/CourseProject/UCI HAR Dataset/train/Y_train.txt",
                col.names = "activities")
subject_test <- read.table("~/DSWD/CourseProject/UCI HAR Dataset/test/subject_test.txt",
                col.names = "subject")
X_test <- read.table("~/DSWD/CourseProject/UCI HAR Dataset/test/X_test.txt",
                col.names = features2)
Y_test <- read.table("~/DSWD/CourseProject/UCI HAR Dataset/test/Y_test.txt",
                col.names = "activities")
alldat <- rbind(cbind(subject_train, Y_train, X_train), cbind(subject_test, Y_test, X_test))

activities <- read.table("~/DSWD/CourseProject/UCI HAR Dataset/activity_labels.txt",
                stringsAsFactors = FALSE)
alldat$activities <- activities[alldat$activities, 2]


# STEP 2
# This extracts the measurements on the mean and standard deviation (std) for each
# variable in "alldat" making a data frame
subData <- grep("-mean\\(\\)|-std\\(\\)", features$V2) # finds all measures with mean or std
meas <- c(subData, ncol(alldat)-1, ncol(alldat)) # adds colums to match alldat
step2 <- alldat[,meas] # subsets alldat by measures with mean or std


# STEP 5
# Creates a second, independent tidy data set with the average for each activity
# and each subject
step5 <- melt(step2, c("subject", "activities"))
ans <- dcast(step5, subject + activities ~ variable, mean)

# Creates a file for the result from STEP 5
write.table(ans, file = "step5.txt", row.name = FALSE) # this writes a .txt w/ answer
