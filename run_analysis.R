# course project
setwd("C:/Users/Kyuu/Desktop/Coursera  - Data Science/Course 3/course project")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data.zip")
filelist <- unzip("./data.zip")

# 1 Merges the training and the test sets to create one data set.
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
# use dim() to get the detail for binding
merge_train <- cbind(subject_train, y_train, x_train)
merge_test <- cbind(subject_test, y_test, x_test)

merge_data <- rbind(merge_train, merge_test)

# 2 Extracts only the measurements on the mean and standard deviation for each measurement.
feature <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = F)[, 2]
feature_index <- grep(("mean\\(\\)|std"), feature)
extract_data <- merge_data[, c(1, 2, feature_index + 2)]
colnames(extract_data) <- c("Subject", "Activity", feature[feature_index])

# 3 Uses descriptive activity names to name the activities in the data set
activity_name <- read.table("./UCI HAR Dataset/activity_labels.txt")
extract_data$Activity <- factor(extract_data$Activity, levels = activity_name[, 1],
                                labels = activity_name[, 2])

# 4 Appropriately labels the data set with descriptive variable names.
colnames(extract_data) <- gsub("-", " ", colnames(extract_data))
colnames(extract_data) <- gsub("\\(\\)", "", colnames(extract_data))
colnames(extract_data) <- gsub("mean", "Mean", colnames(extract_data))
colnames(extract_data) <- gsub("std", "Std", colnames(extract_data))
colnames(extract_data) <- gsub("BodyBody", "Body", colnames(extract_data))
colnames(extract_data) <- gsub("Acc", "Accelerator", colnames(extract_data))
colnames(extract_data) <- gsub("Mag", "Magnitude", colnames(extract_data))
colnames(extract_data) <- gsub("Gyro", "Gyroscope", colnames(extract_data))


# 5 From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
final_data <- extract_data %>%
    group_by(Subject, Activity) %>%
                    summarise_each(funs(mean))

write.table(final_data, "./mean_data.txt", row.names = F)
