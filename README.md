Project for Getting and Cleaning Data
================

The purpose of this project is to prepare tidy data that can be used for later analysis. 

### The Dataset

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data used for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


### run_analysis.R
The R script called run_analysis.R does the following:

1. Download and Unzip the data if not present
2. Read in necessary meta information: activity labels and feature names
  a. Activity labels translate numeric activity flags into human readable activity names
  b. Feature names correspond to the column names of dataset. We further sanitize them into proper column names for R data.frame.
3. Load Training and Testing dataset
  a. Each dataset depends on X (measurements), y (activities), and subject file
  b. Feature names are applied when reading measurements dataset
  c. Activities are translated when reading activities dataset
  d. All three parts formed the new data.frame
4. Merge the two dataset using `rbind`
5. Identify the columns that are `mean()` and `std()`
  a. We excluded `meanFreq()` column because we believe they don't qualify as intended `mean` measurement for the variable
6. Write the filtered dataset into .csv file
7. In addition to the columns we selected in step 5, we also include `subject` and `type` columns, which contains the subject ID and whether s/he were assigned in train or test group.
8. Group the dataset by activity, subject and type, and summarize the dataset by taking the mean of each remaining measurement columns.
9. Write the summarized dataset into .csv file