



#The first step is to download the data in a temporal file.  In order to unzip and read
#the files, I use the function unz().

temporal <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temporal)

#The next step, is reading the TRAIN files, and constructing a data frame with the name of
#the variables, and, the real names of activities.  Also, we need to merge files with the 
#subject that do the activities.
a <- rep(16,561)
s <- read.fwf(unz(temporal,file.path("UCI HAR Dataset","train","X_train.txt")),widths = a,buffersize = 100)
o <- read.fwf(unz(temporal,file.path("UCI HAR Dataset","features.txt")),widths = 36,buffersize = 100,stringsAsFactors=F)
colnames(s) <- c(o[c(1:561),1])
x <- read.fwf(unz(temporal,file.path("UCI HAR Dataset","train","subject_train.txt")),widths = 2,buffersize = 100)
e <- read.fwf(unz(temporal,file.path("UCI HAR Dataset","train","y_train.txt")),widths = 1,buffersize = 100)
e2 <- ifelse(e==1,"WALKING",ifelse(e==2,"WALKING_UPSTAIRS",ifelse(e==3,"WALKING_DOWNSTAIRS",ifelse(e==4,"SITTING",ifelse(e==5,"STANDING","LAYING")))))
y <- cbind(x,e2,s)

#A similar procedure is needed to read the TEST set of files, in order to merge all the data.
b <- rep(16,561)
t <- read.fwf(unz(temporal,file.path("UCI HAR Dataset","test","X_test.txt")),widths = a,buffersize = 100)
colnames(t) <- c(o[c(1:561),1])
u <- read.fwf(unz(temporal,file.path("UCI HAR Dataset","test","subject_test.txt")),widths = 2,buffersize = 100)
f <- read.fwf(unz(temporal,file.path("UCI HAR Dataset","test","y_test.txt")),widths = 1,buffersize = 100)
f2 <- ifelse(f==1,"WALKING",ifelse(f==2,"WALKING_UPSTAIRS",ifelse(f==3,"WALKING_DOWNSTAIRS",ifelse(f==4,"SITTING",ifelse(f==5,"STANDING","LAYING")))))
v <- cbind(u,f2,t)

#The next step is to merge in one data frame the TRAIN and TEST data sets, and after this, 
#with the function aggregate() I calculate the mean of each variable by subject and by activity.
d <- rbind (y,v)
colnames(d) <- c("subject", "activity")
n <- aggregate(d[,3:563], by=list(d$subject,d$activity), FUN=mean)

# In the final steps I use the function grep() to select names of variables that contain mean()
# and std, in order to construct the final Tidy Data Set.  The final step is to write this data
# in a csv file.
colnames(n) <- c("subject", "activity",c(o[c(1:561),1]))
t <- grep ("std",names(n),value = TRUE)
t2 <- grep ("mean\\(\\)",names(n),value = TRUE)
n2 <- n[c("subject","activity",t2,t)]
write.table(n2,file ="Run_Analysis_Tidy_Data_set.txt",sep=",",row.names = FALSE)
unlink(temporal)






