This project creates two "tidy" data sets from the UCI HAR data set

Dataset 1:  meanstd.txt
This data set contains the observations from values that are mean and standard deviations for each measurement
- columns chosen all had variables named mean() or std() for their respective features
- columns such as tBodyAccMean were not included becuase they were considered to be features themselves, not means or standard deviations of features

This dataset is tidy because:
-Each row is an observation - a unique combination of subject, activity, type(test or training)
-Each column is a variable:
  - Identifier variables are subject.number; type, activity.name
  - Measurement variable are the 66 mean and std values of the features/variables captured

Logical  Approach - Each step below is a commented section of code

1. Read features.txt; and activity_labels.txt file 
- These were read in first as individual files that were used to merge into final results
    - feature.txt contains the 561 feature/variable combinations that were in the measurement data
    - activity_labels.txt contains the names of the 6 activities

2. Identify feature numbers  and feadturenamesof 561 containing "mean()" or "std()"
- select the sequence number of features containing mean( or std(; used later to subset the X data sets
- select the names associated with the selected feature;  used later for column names

3. Modify featurenames to be used as for column names of new data frame
- edits the feature names for readable column headings
   - remove special characters ()
   - replace - with .  as separater for X, Y, Z dimensions
   - replace t with time and f with frequency to be explicit
- formatting based on google R style with two exceptions for readability in this situation
    - . used to separate compound names
    - leading Captial letter retained, preservering data sets original designation of features and variables

4. Modify activty names to use as values (lower case) 
- Consistent with goole R style

5. Read subject_train.txt;  subject_test.txt; y_train.txt; y_test.txt
- This reads the data sets that are "clubbed" to the main data  (subject number and activity number)

6. Read X_train.txt and X_test.txt - columns with mean() and std()
- This reads the main data sets, limitng the columns stored to those identified as mean( or std( in step 2
- This uses the associated names in step 2, with edits in step 3 as column names

7. Add type column to xtrain and xtest 
- Clubs a column for type,  with fixed value of test for the test data set and  train for the train data set

8. Add activity to xtest and xtrain
- Clubs a column for activity number from the Y data sets read in step 5.

9. Add subject to xtest and xtrain
- Clubs a column for subject number from the subject data sets read in step 5.

10. Replace activity number with Activity Name
- Merges the Activity name from data read in step 1.; and deletes activity number

11. Combine test and training data and reorder columns to put all mean and std variable to right
- Combines the rows from test and train
- reorders columns so that all idnetifier variables are to the left and measurement variables to the write

12. Create summarymeanstd.txt - summmary data frame
- Dataframe remains "tidy"
  - each row is now an observation of mean of subject and activity  (30 subjects x 6 activities yields 180 rows)
  - each column remains the identifier variables, and the 66 features/variables of mean and std

