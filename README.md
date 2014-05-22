GettingAndCleaningDataCourseProject
===================================

Course project for the Coursera course Getting and Cleaning Data.

The run_analysis.R script:
1) Reads in the activity labels and feature labels.
2) Reads in the test data set.
3) Selects the mean and std variables.
4) Removes punctuation from feature names using the stringr package for easier reading.
5) Reads in the numeric activity labels and replaces them with text descriptions.
6) Adds the activity labels to the variables.
7) Reads in the subject labels and adds them to the variables.
8) Repeats steps 2-7 on the train data set.
9) Merges the two data sets.
10) Calculates the mean for each variable for each activity and each subject.
11) Writes the output to a text file.
