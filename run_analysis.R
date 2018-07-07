
# 1. Merge training and test datasets

# 1a. import 561-feature vector and append training/test
test_meas <- read.table("test/X_test.txt")
train_meas <- read.table("train/X_train.txt")
full_meas <- rbind(train_meas,test_meas)

# 1b. import subject IDs and append training/test
train_subj <- read.table("train/subject_train.txt")
test_subj <- read.table("test/subject_test.txt")
full_subj <- rbind(train_subj,test_subj)

# 1c. import activity IDs and append training/test
train_act <- read.table("train/y_train.txt")
test_act <- read.table("test/y_test.txt")
full_act <- rbind(train_act,test_act)

# 4. Appropriately labels datasets with descriptive variable names

# 4a. import feature names
featurenames <- read.table("features.txt",stringsAsFactors = FALSE)
columnnames <- featurenames[,2]

# 4b. name appended measurements dataset
colnames(full_meas) <- columnnames

# 2. Extracts only the measurements on the mean and sdev for each measurement

# extract required features only and filter measurements dataset
reqfeat <- grep("-mean\\(\\)|std\\(\\)",columnnames)
full_meas <- full_meas[,reqfeat]

# 3. Uses descriptive activity names for the activities in the dataset

# 3a. get activity names
actnames <- read.table("activity_labels.txt",stringsAsFactors = FALSE)

# 3b. clean names
names(full_meas) <- gsub("\\(|\\)","",names(full_meas))
names(full_act) <- "activityID"
names(full_subj) <- "subject"
actnames[,2] <- gsub("_","",actnames[,2])

# 3c. merge clean columns and add activity labels by ID - clean dataset 1 : "tidy"
tidy <- cbind(full_subj,full_meas,full_act)
tidy$activityname <- factor(tidy$activityID,levels=actnames$V1,labels=actnames$V2)

# 5.Create a second independent dataset with the avg of each variable for each activity for each subject

# summarise by mean for each subject for each activity - clean dataset 2 : "tidy2"
library("dplyr")
tidy2 <- tidy %>% group_by(subject,activityname) %>% summarise_all(funs(mean))