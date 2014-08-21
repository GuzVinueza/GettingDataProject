Study Design
=============
The data was collected from the following repository:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

It corresponds to information of accelerometer and gyroscope of a Samsung Galaxy II that was carried on the waist of 30 volunteers.  Every volunteer had different activities and the lectures of these instruments (linear acceleration and angular velocity) were captured.

Additional information could be found here: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The idea of this Project is to utilize this information and convert it into manageable data that could tell the user more about these phenomena. 

Five steps were detailed in the Project as part of its completion, and they will be detailed in the next section:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


Code book
=========

- **1.Merges the training and the test sets to create one data set.**

As explained above, 70% and 30% of the information were disaggregated in different folders (/train and /test).  The information of the 561 positions is located in X_train or X_test file, and the information for the activities in Y_train and Y_test files.  These files were consolidated in this way:

- X_test (testdat) = X_train (traindat) + X_test (testdat)
- Y_test (testact) = Y_train (trainact) + Y_test (testact)

The rbind function was used to generate the variables and join them together.  Each file was read using the read.table function.  Total number of rows = 10299 (7352 [train] + 2947 [test])

- **2. Extracts only the measurements on the mean and standard deviation for each measurement.**

The testdat data set has 561 columns, and in order to get the mean and std. dev .for each column it was necessary to generate an internal structure with the same column set (meansddat), which initially copies the information from the first 2 columns, and during the process is automatically updated using the "mean" and "sd" function.

The loop generates a column count for each one of the 561 columns and two rows.  In the first row it assigned the Mean, and in the second row it assigns the Standard Deviation.

Variable used: "meansddat" 

- **3. Uses descriptive activity names to name the activities in the data set.**

For this task I added two new columns to the testdat dataset:
- Column #562 is the Activity Code, which comes from the testact data frame
- Column #563 is the Activity Name, which comes from the "activity_labels.txt" file which contains the 6 possible activity names

The process runs for each row of the testdat data set and assigns these new columns correspondingly.  For column #563 a subset command is used, in order to filter which activity name is being used every time.

The "testact_col" data frame is used to hold the activity_labels.txt file


- **4. Appropriately labels the data set with descriptive variable names.**

The dataset that comes as a result from the rbind process doesn´t have any descriptive variable name related.  That means it has names for each column like V1, V2, ...., V561.  This process uses the colnames command in order to get descriptive column names according to the "features.txt" file, which contains the 561 different names for the columns.  For the last two columns of the "testdat" data set the colnames function is used and the names assigned manually.

Both the "testdat" and "meansddat" data sets were updated with this information.  


- **5. Creates a second, independent tidy data set with the average of each variable for each activity and each.** subject.

Finally, a new dataset called "secondset" is generated.  This dataset is required to have 3 columns: (1) variable, (2) activity, (3) mean.  This data frame is designed with these fields.

The process is repeated for each column (561 times) and for each activity (6 times), so a total of 3366 lines are projected for this data frame to hold, corresponding to each activity and each measurement.

The nested loop implemented generates the Variable and Activity directly from the "testdat" data set, and it will calculate the mean based on the activity.  Let's remember that the activity was already added to the "testdat" data frame and it will fall under the column name ActivityName.

See a fragment of the data set:

{|
id|        variable   |        activity   |  mean    
--|-------------------|-------------------|----------
1 | tBodyAcc-mean()-X |           WALKING |0.2763369 
2 | tBodyAcc-mean()-X |  WALKING_UPSTAIRS |0.2622946 
3 | tBodyAcc-mean()-X |WALKING_DOWNSTAIRS |0.2881372 
4 | tBodyAcc-mean()-X |           SITTING |0.2730596 
5 | tBodyAcc-mean()-X |          STANDING |0.2791535 
6 | tBodyAcc-mean()-X |            LAYING |0.2686486 
|}
