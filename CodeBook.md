The data frame produced by the script `run_analysis.R` contains the following columns:

     [1] "Activity"                "SubjectId"               "avg..tBodyAcc.mean.X"    "avg..tBodyAcc.mean.Y"   
     [5] "avg..tBodyAcc.mean.Z"    "avg..tBodyAcc.std.X"     "avg..tBodyAcc.std.Y"     "avg..tBodyAcc.std.Z"    
     [9] "avg..tGravityAcc.mean.X" "avg..tGravityAcc.mean.Y" "avg..tGravityAcc.mean.Z" "avg..tGravityAcc.std.X" 
    [13] "avg..tGravityAcc.std.Y"  "avg..tGravityAcc.std.Z"  "avg..tBodyGyro.mean.X"   "avg..tBodyGyro.mean.Y"  
    [17] "avg..tBodyGyro.mean.Z"   "avg..tBodyGyro.std.X"    "avg..tBodyGyro.std.Y"    "avg..tBodyGyro.std.Z"

There are 2 index columns (`Activity` and `SubjectId`), and 18 value columns.

The `Activity` column contains the activity name as listed in the file `activity_labels.txt` from the original archive.  There are six possible values:

* `WALKING`
* `WALKING_UPSTAIRS`
* `WALKING_DOWNSTAIRS`
* `SITTING`
* `STANDING`
* `LAYING`

The `SubjectId` column contains the id of the subject from whose device the measurements were collected.  These ids are integer values covering the range between 1 and 30.

The rest of the columns are averages of the mean (marked `mean`) and standard deviation (marked `std`) columns found in the original data set.  The meaning of each column should be clear from the column names, which follow a consistent format.

The numbers in the value columns are of 16 decimal point precision.  It is not clear from the description of the original data what the units of measurement are for the collected data, but the value columns in the output of `run_analysis.R` preserve the respective original units.

The output is persisted to a plain text file called `output.txt`, which contains a header line, and has the columns separated by a space character.

