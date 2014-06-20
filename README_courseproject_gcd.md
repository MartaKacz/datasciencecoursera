Course project of Getting and Cleaning Data from Coursera
========================================================


I started with setting working directory on my local computer. Next step is reading all the data with function read.table() and changing their dimensional with dim() function.

I changed a little an order of task for my convenience. So first I have made a step 4 (adding features names) with function colnames(), then I merged a descriptive activity names to name the activities in the data sets (train and test). I also added logical variable "test" (1 - observation from test subset, 0 observation from train subset). Then I had two subset X.train and X.test with the same coloumns so I merged them with function 
rbind() and called it my.frame. The dimensions of my.frame is  10299 rows and  564 columns.

Next step was to add subject variable into my.frame and extracts only the measurements on the mean and standard deviation for each measurement. I used function grep() to find the names of variables which contains "mean()" and "std()". I called the final data as tidy.data.

At the end I created new tidy data set with the average of each variable for each activity and each subject. The function that I used to split is split(). Then I used lapply() to calculating average of each variable for each activity and each subject. The last step was to write new tidy data called tidy.data.with.averages into txt file.






