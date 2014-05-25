# Code to access test and train folders inside UCI HAR Dataset, extract 
# files, merge them and create a different dataset with only mean of each variable
# for each activity level and subject id

# Setting wd to 'Dataset' ('UCI HAR Dataset' name must be changed to 'Dataset' for code to work)
# after first extracting the current working directory
# Note: The file 'Dataset' must be inside the working directory
Original <- getwd()
setwd("./Dataset")

# Reading in all 6 data files from 'test' and 'train' folders
TestSet <- read.table("./test/X_test.txt")
TestLabels <- read.table("./test/y_test.txt")
TestActivity <- read.table("./test/subject_test.txt")

TrainSet <- read.table("./train/X_train.txt")
TrainLabels <- read.table("./train/y_train.txt")
TrainActivity <- read.table("./train/subject_train.txt")

# Merging individual .txt files inside Test and Train datasets
CombSet <- rbind(TestSet,TrainSet)
CombLabels <- rbind(TestLabels,TrainLabels)
CombActivity <- rbind(TestActivity,TrainActivity)

# Combining merged datasets into one complete data set
CombDataSet <- cbind(CombActivity,CombLabels,CombSet)

# Extracting column names from features.txt and attaching them to data set created
FeatNames <- read.table("./features.txt",stringsAsFactors = F)
colnames(CombDataSet) <- FeatNames[,2]

# Create a new data set that only contains measurements of mean and standard deviation
FinalDS <- CombDataSet[grep("mean\\(\\)|std\\(\\)",names(CombDataSet))]

# Modify column names so as to make them 'appropriate' and 'descriptive'
# Style guide referred to is "https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml"
# First, remove all brackets and hyphens
names(FinalDS) <- gsub("\\(\\)","",names(FinalDS))
names(FinalDS) <- gsub("\\-","",names(FinalDS))

# Now change names by removing caps and inserting periods
names(FinalDS) <- gsub("A",".a",names(FinalDS))
names(FinalDS) <- gsub("B",".b",names(FinalDS))
names(FinalDS) <- gsub("G",".g",names(FinalDS))
names(FinalDS) <- gsub("J",".j",names(FinalDS))
names(FinalDS) <- gsub("M",".m",names(FinalDS))
names(FinalDS) <- gsub("X",".x",names(FinalDS))
names(FinalDS) <- gsub("Y",".y",names(FinalDS))
names(FinalDS) <- gsub("Z",".z",names(FinalDS))
names(FinalDS) <- gsub("mean",".mean",names(FinalDS))
names(FinalDS) <- gsub("std",".std",names(FinalDS))

# NOTE: Only doing this in a roundabout way because the assignment
# asks for a *COMPLETE* data set prior to extracting of the mean and std
FinalDS <- cbind(CombDataSet[,1],CombDataSet[,2],FinalDS)

# Now renaming the first two columns again
colnames(FinalDS)[c(1,2)] <- c("subject","activity.labels")

# Converting the first two columns to numeric prior to reshaping
FinalDS[,1] <- as.numeric(FinalDS[,1])
FinalDS[,2] <- as.numeric(FinalDS[,2])

# Reshaping the dataset to a tall skinny dataset
library(reshape2)
FinalDS <-melt(FinalDS, id=c("subject", "activity.labels"))

# Ordering the reshaped dataset in ascending order of subject no (1-30)
# with ties being broken by activity label (1-6) 
FinalDS  <- FinalDS[ order(Trial[,1], Trial[,2]),]

# Now get mean of all columns for each subject and each activity using dcast
FinalCDS <- dcast(Trial, subject + activity.labels ~ variable, fun.aggregate=mean)

# Writing file to directory
setwd(Original)
write.table(FinalCDS, file = "CleanDataSet.txt",row.names=F, sep = "\t")
#If you want .csv
write.csv(FinalCDS, file = "CleanDataSet.csv",row.names=F)