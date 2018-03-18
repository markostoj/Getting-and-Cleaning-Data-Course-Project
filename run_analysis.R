# source data & libraries ----

library(dplyr)
library(ggplot2)
library(tidyr)
library(data.table)
library(stringr)
library(plyr)

setwd("C:/Users/shaban/Desktop/Coursera/R_projects/Corsera_Week_4/UCI HAR Dataset/")

# read data -----
features <- read.table("./features.txt", sep="", header=FALSE)
activity_labels <- read.table("./activity_labels.txt", sep="", header=FALSE)

# clean -----
features$V2<-str_replace_all(features$V2, "-", "")
features$V2<-str_replace(features$V2, "[()]", "")
features$V2<-str_replace(features$V2, "[)]", "")

# read data ----- have 30 people, subjects
subject_train <- read.table("./train/subject_train.txt", sep="", header=FALSE)
x_train <- read.table("./train/X_train.txt", sep="", header=FALSE) # variables for prediction
y_train <- read.table("./train/y_train.txt", sep="", header=FALSE) # predict activity

subject_test <- read.table("./test/subject_test.txt", sep="", header=FALSE)
x_test <- read.table("./test/X_test.txt", sep="", header=FALSE)
y_test <- read.table("./test/y_test.txt", sep="", header=FALSE)

# Add column names
colnames(activity_labels)<-c("activityId","activityType")

# rename columns

colnames(subject_train) <- "subId"
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"

colnames(subject_test) <- "subId"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"

# 1. Merge the training and the test sets to create one data set.

train_data <- cbind(subject_train,y_train,x_train)
test_data <- cbind(subject_test,y_test,x_test)
final_clean_data <- rbind(train_data,test_data)

# 2. Extract only the measurements on the mean and standard deviation for each measurement

mean_std_data <-final_clean_data[grepl("mean|std|activityId|subId",colnames(final_clean_data))]

# 3. Uses descriptive activity names to name the activities in the data set

mean_std_data <- inner_join(mean_std_data, activity_labels, by = "activityId")
colnames(mean_std_data)

# 4. Appropriately labels the data set with descriptive variable names. 
tidydataset<- ddply(mean_std_data, c("subId","activityId"), numcolwise(mean))

# 5.From the data set in step 4, creates a second, independent
                #tidy data set with the average of each variable for each activity and each subject.
write.table(tidydataset,file="tidy_data.txt")


