setwd("/Users/hederferreira/Dev/Estudos/r/3_get_and_cleanning_data/week4/Project")

require(dplyr)

#assuming you are in the same directory as the "UCI HAR Dataset"
setwd("./UCI HAR Dataset")

#Load test files
x_test <- read.table("./test/X_test.txt")
x_test_subject <- read.table("./test/subject_test.txt")
y_test <- read.table("./test/y_test.txt")

#Merge loaded test files in same data frame
x_test$subject_id <- x_test_subject[[1]]
x_test$activity_id <- y_test[[1]]

#Load train files
x_train <- read.table("./train/X_train.txt")
x_train_subject <- read.table("./train/subject_train.txt")
y_train <- read.table("./train/y_train.txt")

#Merge loaded train files in same data frame
x_train$subject_id <- x_train_subject[[1]]
x_train$activity_id <- y_train[[1]]

#Union two main data frames
final_df <- union_all(x_test,x_train)

#Load features column names
features <- read.table("features.txt", col.names = c('feature_id','feature')) 
#features$feature <- gsub('[,\\(\\)]|-', '_', features$feature)

#Set currect names to main data frame variables
names(final_df) <- union_all(features[,2], c("subject_id","activity_id"))

#Load activity labels
activity_labels <- read.table("activity_labels.txt", col.names = c("activity_id", "activity"))

#Merge main data frame with Activity Name
final_df <- merge(final_df, activity_labels)

#Define final data frame
######################################################
#Filtering column names
colnames <- names(final_df)
colindex_mean_std <- grep('((mean|std)\\(\\))',colnames)
colindex_act <- grep('^activity$',colnames)
colindex_sub <- grep('^subject_id$',colnames)
#Defining columns order
colindex <- union_all(colindex_act, colindex_sub, colindex_mean_std)

#Ordering lines by activity and subject_id
final_df <- arrange(final_df[, colindex], activity, subject_id)

write.table(final_df, "./final_df.txt", sep="\t") 

#Create data frame of means
######################################################
#Group df by activity and subject_id
groups <- group_by(final_df, activity, subject_id)

#calculate mean of all columns by groups
averages_df <- summarize_all(groups, mean)

write.table(averages_df, "./averages_df.txt", sep="\t") 


