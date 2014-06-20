### Marta Kaczmarz
### Coursera
### Getting and Cleaning Data
### Course project
### 20.06.2014



### 0. seting work directory
setwd("C:/Users/mkaczmarz/Desktop/Coursera/UCI HAR Dataset")


### 1.Merging the training and the test sets to create one data set.

## reading the data
subject.train <-read.table("./train/subject_train.txt")
# dim(subject.train)
# [1] 7352    1

subject.test<-read.table("./test/subject_test.txt")
# > dim(subject.test)
# [1] 2947    1

features <- read.table("./features.txt")
# > dim(features)
# [1] 561   2

activity.labels <- read.table("./activity_labels.txt")

X.train <- read.table("./train/X_train.txt")
#dim(X.train)
#[1] 7352  561

Y.train <- read.table("./train/y_train.txt")
#dim(Y.train)
#[1] 7352  1

X.test <- read.table("./test/X_test.txt")
#dim(X.test)
#[1] 2947  561

Y.test <- read.table("./test/y_test.txt")
#dim(Y.test)
#[1] 2947  1


### add features names to X.train (4.Appropriately labels the data set with descriptive variable names)
colnames(X.train)<-as.character(features[,2])
colnames(X.test)<-as.character(features[,2])


### 3.Uses descriptive activity names to name the activities in the data set

#merging labels with class names
colnames(Y.train) <-"labels"
mergedLevels.train = merge(Y.train, activity.labels, by.x = "labels",by.y = "V1", all =TRUE) 

#merging labels with class names
colnames(Y.test) <-"labels"
mergedLevels.test = merge(Y.test, activity.labels, by.x = "labels",by.y = "V1", all =TRUE) 

# adding logical variable if test or train group
X.test$test <- rep(1, nrow(X.test))
X.train$test <- rep(0, nrow(X.train))

# adding labels and class
X.train$activity.labels <-mergedLevels.train[,1]
X.train$activity.class <-mergedLevels.train[,2]

# adding labels and class
X.test$activity.labels <-mergedLevels.test[,1]
X.test$activity.class <-mergedLevels.test[,2]

# merging train and test obserwation in one frame
my.frame<-rbind(X.train, X.test)
# > dim(my.frame)
# [1] 10299   564

# adding subject
my.frame$subject <-c(subject.train$V1, subject.test$V1)


### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features.with.mean <- grep("mean()" , names(my.frame))
features.with.sd <- grep("std()" , names(my.frame))

tidy.data<-my.frame[,c(features.with.mean, #measurements on the mean 
                       features.with.sd, #measurements on the std
                       # another important variables
                       which(names(my.frame) =="activity.class"),
                       which(names(my.frame) =="activity.labels"),
                       which(names(my.frame) =="subject"),
                       which(names(my.frame) =="test")
                       )]

head(tidy.data)



### 5. Creating  tidy data set with the average of each variable for each activity and each subject

# spliting data
splited.data <-split(tidy.data, list(my.frame$activity.class,my.frame$subject))

# calculating average of each variable for each activity and each subject 
feat.means<-lapply(splited.data, function(x)
  {
    # creating new empty vector
    feat.mean<-numeric(ncol(tidy.data)-4)
    
    for(i in 1:(ncol(tidy.data)-4))
    {
      feat.mean[i] <-mean(x[,i])
    }
    return(feat.mean)
  }
  )
  
# data frame with the average of each variable (rows) for each activity and each subject (columns)
tidy.data.with.averages<-data.frame(feature = names(tidy.data)[1:(ncol(tidy.data)-4)], feat.means)
head(tidy.data.with.averages)

#transpozytion of data.frame (if somebody preffer another view)
trans<-t(tidy.data.with.averages)[-1,]
colnames(trans)<-names(tidy.data)[1:(ncol(tidy.data)-4)]

tidy.data.with.averages<-trans

write.table(tidy.data.with.averages,file = "tidy.data.with.averages.txt")

tab<-read.table("tidy.data.with.averages.txt")
