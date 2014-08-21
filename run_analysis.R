
## Gustavo Vinueza - gvinueza@gmail.com - 2014.08.20

## Final Project - Getting and Cleaning Data
## Set Local folder to be used

setwd("C:/Users/gustavo/_Coursera/GettingData/Project")

## 1. 
## Read files and binding of Training and Testing data
## Pending as file would be too big to work with!
traindat <- read.table("./train/X_train.txt")
testdat <- read.table("./test/X_test.txt")

trainact <- read.table("./train/Y_train.txt")
testact <- read.table("./test/Y_test.txt")

## Makes testact and testdat the final variable by adding the trainact
testdat <- rbind(testdat, traindat)
testact <- rbind(testact, trainact)

## 2. 
## Extracts mean and Std Dev for each measurement
## Generates a new data structure called meanssddata which has 2 rows, and the same structure
## of testdat (main data table)
meansddat <- head(testdat,2)

## For each column, it generates its mean and standard deviation using the mean and sd function
for (j in 1:561)
  {
  for (i in 1:2)
  {
    if (i == 1) {  meansddat[1,i] = mean(testdat[,j])
                  ## print(paste("mean=", meansddat[1,i]))
    }
    else 
    {
      meansddat[2,i]  = sd(testdat[,j])
      ## print(paste("sd=", meansddat[2,i]))
    }
  }
}


## Reference test: 
head(meansddat)


## 3
## Adds 2 new columns to the testdat data set to save the activity and the activity name
## columns are #562 (Activity Code) and #563 Activity Name

## Reads the Activity Labels
testact_col <- read.table("activity_labels.txt")

for (i in 1:nrow(testact)) {
  # Generates the Activity code as an additional column
  testdat[i,562] = testact[i,1]  
  # Generates the Activity Name as an additionak column
  testdat[i,563]<- subset(testact_col[2], testact_col==testact[i,1]  )  
}

## Reference test: 
head(testdat)

## 4. 
## Puts descriptive names to activities in columns of the dataset
## For testdat it adds special columns 562 and 563 described before
testcol <- read.table("features.txt")
colnames(testdat) <- testcol$V2
colnames(testdat)[562] <- "ActivityCode"
colnames(testdat)[563] <- "ActivityName"

colnames(meansddat) <- testcol$V2

## Reference test: 
head(testdat)
head(meansddat)

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
## Generates "secondset" as the new data set
## Columns are: 
##  1. variable
##  2. activity 
##  3. mean

## Generates the secondset data frame
secondset <- data.frame("variable" = character(100), activity=character(20), mean = numeric(10),stringsAsFactors=FALSE)
n = 1

## For each column it generates the 6 activities' statistics
for (i in 1:561)
{
  ## For each activity
  for (j in 1:6)
  {
    tmp_variable <- as.character(testcol[i,2])
    tmp_activity <- as.character(testact_col[j,2])
    # Generates the mean and retrieves the second column (TRUE)
    tmp_mean <- sapply(split(testdat[,i],testdat$ActivityName==as.character(tmp_activity)),mean)[2]      
    print(paste(n, " ", j))
    secondset [n,1] <- as.character(tmp_variable)
    secondset [n,2] <- tmp_activity
    secondset [n,3] <- tmp_mean
    n <- n + 1
  }

}

## Reference test: 
head(secondset)

## Generate data for submitting
write.table(secondset, "step5.txt", row.name=FALSE)
