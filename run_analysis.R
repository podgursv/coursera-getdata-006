###  https://class.coursera.org/getdata-006/human_grading/view/courses/972584/assessments/3/submissions
###
###  Vlad Podgurschi
###  vlad@podgurschi.org


###  read in the necessary data
###  in these cases, default arguments for read.table work best
te_X <- read.table("UCI HAR Dataset/test/X_test.txt")
tr_X <- read.table("UCI HAR Dataset/train/X_train.txt")

te_y <- read.table("UCI HAR Dataset/test/y_test.txt")
tr_y <- read.table("UCI HAR Dataset/train/y_train.txt")

te_sub <- read.table("UCI HAR Dataset/test/subject_test.txt")
tr_sub <- read.table("UCI HAR Dataset/train/subject_train.txt")

features <- read.table("UCI HAR Dataset/features.txt")[,2]

activities <- read.table("UCI HAR Dataset/activity_labels.txt")
activityColNames <- c("ActivityId", "Activity")    ###  to be used later as well
colnames(activities) <- activityColNames


################
###  step 1 - Merges the training and the test sets to create one data set.
################

allData <- rbind(tr_X, te_X)


################
###  step 2 - Extracts only the measurements on the mean and standard deviation
###           for each measurement
################

###  finding the required columns is better done using the original feature names,
###  as found in features_info.txt;  per README.txt:
###  -  measurements have this column name format:  tAcc-XYZ and tGyro-XYZ
###     (the other metrics are DERIVED from the ORIGINAL measurements, and so will not be retained)
###  -  Acc is split into tBodyAcc-XYZ and tGravityAcc-XY
###  -  mean and std columns contain mean() and std() in the name (case sensitive)
rx <- "^t.*(Acc|Gyro)-.*(mean|std)\\(\\).*"    ###  Perl-style regex to encapsulate the points above

#  [1] "tBodyAcc-mean()-X"    "tBodyAcc-mean()-Y"    "tBodyAcc-mean()-Z"    "tBodyAcc-std()-X"
#  [5] "tBodyAcc-std()-Y"     "tBodyAcc-std()-Z"     "tGravityAcc-mean()-X" "tGravityAcc-mean()-Y"
#  [9] "tGravityAcc-mean()-Z" "tGravityAcc-std()-X"  "tGravityAcc-std()-Y"  "tGravityAcc-std()-Z"
# [13] "tBodyGyro-mean()-X"   "tBodyGyro-mean()-Y"   "tBodyGyro-mean()-Z"   "tBodyGyro-std()-X"
# [17] "tBodyGyro-std()-Y"    "tBodyGyro-std()-Z"

###  select required columns by position
selectColumns <- grep(rx, features, perl = TRUE)
meanAndStd <- allData[ , selectColumns]

################
###  step 3 - Uses descriptive activity names to name the activities in the data set
################

###  construct the subjects column for the whole data set
activityIds <- rbind(tr_y, te_y)   ###  must be in the same order as in allData

###  IMPORTANT:  due to the fact that merge operation resorts the rows,
###              the activities column must be bound to the main data set,
###              BEFORE the operation of merging with the activity names
meanAndStdWAct <- cbind(ActivityId = activityIds$V1, meanAndStd)

meanAndStdWAct <- merge(activities, meanAndStdWAct, by = "ActivityId")


################
###  step 4 - Appropriately labels the data set with descriptive variable names
################

###  the goal is to have the column names:
###  -  be legal names in R
###  -  be consistent
###  -  resemble the original as much as possible
cleanColNames <- lapply(features[selectColumns], function(x) { gsub("\\.+", ".", make.names(x)) })

colnames(meanAndStdWAct) <- c(activityColNames, cleanColNames)


################
###  step 5 - Creates a second, independent tidy data set with the average of
###           each variable for each activity and each subject.
################

###  assuming the ask is to build on top of the smaller data set constructed in the previous steps

###  construct the subjects column for the whole data set
subjectIds <- rbind(tr_sub, te_sub)   ###  must be in the same order as in allData

###  due to the fact that we merged the activity ids with the names above,
###  the rows in meanAndStdWAct are re-sorted, and the order no longer corresponds
###  with the order in subjectIds, so we have to go back and work with meanAndStd,
###  which has the rows in the same order as subjectIds and activityIds
avgMeanAndStd <- aggregate(x = meanAndStd,
                           by = list(SubjectId = subjectIds$V1, ActivityId = activityIds$V1),
                           FUN = "mean", na.rm = TRUE)

###  now merge again with the activity names
avgMeanAndStd <- merge(activities, avgMeanAndStd, by = "ActivityId")

###  the activity Id column is no longer needed;  will retain the descriptive names for activities
avgMeanAndStd <- subset(avgMeanAndStd, select = c(-ActivityId))

###  for calculated averages, name the columns "avg..X", where X is the original
colnames(avgMeanAndStd)[3:length(avgMeanAndStd)] <- lapply(cleanColNames, function(x) { paste("avg..", x, sep = "") })


###  output to disk
write.table(avgMeanAndStd, file = "output.txt", row.names = FALSE)


#########################################################################

###  function to spot-check the result
###  usage:
###      spotCheck(avgMeanAndStd, 123, 12)
###  or  spotCheck(avgMeanAndStd,
###                sample(1:dim(avgMeanAndStd)[1], 1),
###                sample(1:dim(avgMeanAndStd)[2], 1))
###  or  spotCheck(avgMeanAndStd)
###  or  lapply(1:30, function(x) { spotCheck(avgMeanAndStd) })
spotCheck <- function(data, outputRow = 0, outputColumn = 0) {
  dataDim <- dim(data)

  h <- dataDim[1]
  w <- dataDim[2] - 2
  if (outputRow < 1) outputRow <- sample(1:h, 1)
  else if (outputRow > h) stop("max row is ", h)

  if (outputColumn < 1) outputColumn <- sample(1:w, 1)
  else if (outputColumn > w) stop("max col is ", w)

  message("XXXXXX: ", outputRow, " x ", outputColumn)

  outData <- data[outputRow, c(1, 2, outputColumn + 2)]
  outSubId <- outData$SubjectId
  outAct <- outData$Activity
  outActId <- activities[activities$Activity == outAct, 1]

  message("XXXXXX: ", "activity: ", outAct, " -> ", outActId)

  outColumn <- names(outData)[3]
  outValue <- outData[[3]]

  ###  compute the mean by finding the rows with given subject and activity
  s1 <- subjectIds[ , 1]
  a1 <- activityIds[ , 1]
  c1 <- cbind(1:length(s1), s1, a1)
  r1 <- c1[s1 == outSubId & a1 == outActId, 1]
  m1 <- mean(allData[r1, selectColumns[outputColumn]])

  ok <- m1 == outValue
  message("Result: ", ok, "  SubjectId: ", outSubId, " Activity: ", outAct,
          " Variable: ", outColumn, " Value: ", outValue)
  if (!ok)
    message("computed: ", outValue, " - checked: ", m1)

  ok
}

