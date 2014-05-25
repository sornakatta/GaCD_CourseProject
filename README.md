Getting and Cleaning Data Course Project
==================
This README.md walks through the necessary steps to execute run_analysis.R. The Codebook.md file contains a list and description of all the variables in the final tidy data set.  

**Requirements**

* The original dataset downloaded must be renamed 'Dataset'. This is purely for convenience and to ensure that a slightly different name does not trip up the script.
* The working directory must contain the file 'Dataset'.
* The R package *reshape2* must be installed on the system.

**Assumptions and Choices**

* The guidelines require selection of the columns which contained mean and standard deviation measurement of each instrument.
* Regexing with just 'mean|std' would result in the selection of 79 columns, but included columns like '*meanFreq()*' which are not mean measurements.
* Hence, a slightly more sophisticated regex was specified which returned 66 variable measurement columns.
* The stylistic choices for naming variables or column names were made based on the recommendations in this [link] (https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml).
* All hyphens, brackets and upper case letters were removed. Periods were used to separate words to follow suggested good labelling practice.
* For example, '*tBodyAcc-mean()-X*' was converted to '*t.body.acc.mean.x*'
* The list of variables and their descriptions can be found in codebook.md

**Code Operation**

* Download run_analysis.R into your working directory.
* Execute script using R.
* The clean data sets will be created in the same directory in both *.txt* and *.csv* formats.

**Process**

* The script reads in data from *X_test.txt*, *y_test.txt* and *subject_test.txt* files in both *train and *test* folders.
* It then combines all the information together to form a single unified data frame ('CombDataSet').
* This combined data set (10299\*563) is then pruned to just those columns containing mean and standard deviation measurements ('FinalDS').
* The variable names are modified using *gsub*
* Using the *melt* function from the *reshape2* library, the data set is converted into a more manageable shape
* The columns are ordered by subject id and activity level
* Using *dcast*, the final tidy data set containing only the average of each variable for each subject id and activity level is created ('FinalCDS')
* The resulting file is written out to 'CleanDataSet.txt' and 'CleanDataSet.csv' in the working directory
