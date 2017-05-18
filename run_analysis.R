# creates meanstd.txt - file of mean and std for test and train data
# creates summarymeanstd.txt file of means groups by subject and activity
library(stringr)
library(data.table)
library(dplyr)

# read features.txt; and activity_labels.txt file 
features <- read.csv("features.txt", stringsAsFactors = FALSE, sep = " ", header = FALSE, col.names = c("number","feature_variable"))
activity <- read.csv("activity_labels.txt", stringsAsFactors = FALSE, sep = " ", header = FALSE, col.names = c("activity","activity.name"))

# identify feature numbers  and feadturenamesof 561 containing "mean()" or "std()"
featurenums <- features[grep( "mean\\(\\)|std\\(\\)",features[,2]),1]
featurenames <- features[grep( "mean\\(\\)|std\\(\\)",features[,2]),2]
                         
# modify featurenames to be used as for column names of new data frame
#    replace “-” with “.”
#    remove ()
#    replace t with time; f with frequency
featurenames <- gsub("-", ".", featurenames)
featurenames <- gsub("\\(\\)", "", featurenames)
featurenames <- gsub("^t", "time.", featurenames)
featurenames <- gsub("^f", "frequency.", featurenames)

# Modify activty names to use as values (lower case) 
activity[,2]  <- str_to_lower(activity[,2])

# read subject_train.txt;  subject_test.txt; y_train.txt; y_test.txt
SubjectTrain <- read.csv("./train/subject_train.txt", stringsAsFactors = FALSE, header = FALSE, col.names = c("subject.number"))
SubjectTest <- read.csv("./test/subject_test.txt", stringsAsFactors = FALSE, header = FALSE, col.names = c("subject.number"))
YTrain <- read.csv("./train/y_train.txt", stringsAsFactors = FALSE, header = FALSE, col.names = c("activity"))
YTest <- read.csv("./test/y_test.txt", stringsAsFactors = FALSE, header = FALSE, col.names = c("activity"))

# Read X_train.txt and X_test.txt - columns with mean() and std()
xtrain <- fread("./train/X_train.txt", sep = "auto", stringsAsFactors = FALSE, 
                header = FALSE, select = featurenums, col.names = featurenames)
xtest  <- fread("./test/X_test.txt", sep = "auto", stringsAsFactors = FALSE, 
                header = FALSE, select = featurenums, col.names = featurenames)

# Add type column to xtrain and xtest 
xtest <- mutate(xtest, type = "test")
xtrain <- mutate(xtrain, type = "train")

# Add activity to xtest and xtrain
xtest <- cbind(YTest, xtest)
xtrain <- cbind(YTrain, xtrain)

#Add subjects to xtest and xtrain
xtest <- cbind(SubjectTest, xtest)
xtrain <- cbind(SubjectTrain, xtrain)

# Replace activity number with Activity Name
xtest <- merge(xtest, activity) %>% select(-activity)
xtrain <- merge(xtrain, activity) %>% select(-activity)


# Combine test and training data and reorder columns to put all mean and std variable to right
meanstd <- rbind(xtest,xtrain)
meanstd <- meanstd[, c(1,68,69,2:67)]

# Create summary of meanstd by activty and subject
summarymeanstd <- group_by(meanstd, subject.number, activity.name ) %>%
      summarise_at(c(3:69), mean)

# write the two datasets
write.table(meanstd, file = "meanstd.csv", row.names = FALSE)