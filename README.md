(for the [Coursera Course - Getting and Cleaning Data](https://class.coursera.org/getdata-006/human\_grading/view/courses/972584/assessments/3/submissions))

The project processes data provided by [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The dataset was downloaded on Monday, Aug 18th, 2014 from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip .  A copy of the data is included in this repository. 

This project provides one R script (`run_analysis.R`), which takes *no runtime arguments*, and produces a tidy dataset containing the average of each mean and standard deviation columns computed for the set of **measurements** included in the original dataset, aggregated by subject and activity. In particular, this means that averages are *not* produced for variables **derived** from the original measurements (see the `README.txt` and `features_info.txt` files in the original archive).

The input data is expected to be located in the same directory as the script itself, under a subdirectory named `UCI HAR Dataset`. The expected directory structure (which corresponds to the layout produced by unzipping the original data archive) is the following:

*  `UCI HAR Dataset/`
   *  `features.txt`
   *  `activity_labels.txt`
   *  `test/`
      *  `X_test.txt`
      *  `y_test.txt`
      *  `subject_test.txt`
   *  `train/`
      *  `X_train.txt`
      *  `y_train.txt`
      *  `subject_train.txt`


The input data is processed in the following steps:

1.  read measurements, activity ids and subject ids from the `test/` and `train/` directories, as well as metadata from `features.txt`, `activity_labels.txt`
2.  concatenate the test and train data
3.  manually check for any `NA` values in the data (none were found);  no cleaning of the original data was necessary
4.  extract the columns containing the mean and standard deviation for the **original** measurements (all *derived* columns were excluded).  The criteria for identifying the original measurements were based on the description of the data from `feature_info.txt`:

        The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

5.  concatenate the test and train activity and subject ids, and bind these two columns to the data set produced in step 4.
6.  for each column in the data set, produce the average value across subject and activity
7.  construct column names from the original names by transforming them into legal R names, and prepending `avg..`
8.  replace the column of activity ids with descriptive activity names according to the mapping found in the file `activity_labels.txt`



The the output data frame produced by the script `run_analysis.R` is described in the accompanying code book (CodeBook.md).

