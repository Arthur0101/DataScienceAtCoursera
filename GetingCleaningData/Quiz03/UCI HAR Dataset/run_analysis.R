

activity_labels <- read.table("./activity_labels.txt",col.names=c("activity_id","activity_name"))

features <- read.table("features.txt")
feature_names <-  features[,2]

## Read the test data
testdata <- read.table("./test/X_test.txt")
colnames(testdata) <- feature_names

## Read the id of the test subjects and label it
test_subject_id <- read.table("./test/subject_test.txt")
colnames(test_subject_id) <- "subject_id"

## Read the activity id and label it
test_activity_id <- read.table("./test/y_test.txt")
colnames(test_activity_id) <- "activity_id"


## Read the training data
traindata <- read.table("./train/X_train.txt")
colnames(traindata) <- feature_names

## Read the id of the test subjects and label it
train_subject_id <- read.table("./train/subject_train.txt")
colnames(train_subject_id) <- "subject_id"

## Read the activity id of the training data and label it
train_activity_id <- read.table("./train/y_train.txt")
colnames(train_activity_id) <- "activity_id"



##Combine the test subject id  and the test activity id
test_data <- cbind(test_subject_id , test_activity_id , testdata)

##combine the training subject id and training activity id
train_data <- cbind(train_subject_id , train_activity_id , traindata)

##Combine the test data and the train data
all_data <- rbind(train_data,test_data)


##Keep only columns name with keyword of mean or std
mean_col_idx <- grep("mean",names(all_data),ignore.case=TRUE)
mean_col_names <- names(all_data)[mean_col_idx]
std_col_idx <- grep("std",names(all_data),ignore.case=TRUE)
std_col_names <- names(all_data)[std_col_idx]
meanstddata <-all_data[,c("subject_id","activity_id",mean_col_names,std_col_names)]


##Merge the activities datase with the mean/std values datase 
##to get one dataset with descriptive activity names
descrnames <- merge(activity_labels,meanstddata,by.x="activity_id",by.y="activity_id",all=TRUE)


##Melt the dataset with the descriptive activity names for better handling
data_melt <- melt(descrnames,id=c("activity_id","activity_name","subject_id"))

##Cast the melted dataset according to  the average of each variable 
##for each activity and each subjec
mean_data <- dcast(data_melt,activity_id + activity_name + subject_id ~ variable,mean)

## Create a file with the new tidy dataset
write.table(mean_data,"./tidy_data.txt")