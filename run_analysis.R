setwd("/Users/jiaodavy/UCI HAR Dataset/")

features = read.table("/Users/jiaodavy/UCI HAR Dataset/features.txt", header = FALSE)
activityType = read.table("/Users/jiaodavy/UCI HAR Dataset/activity_labels.txt", header = FALSE)
subjectTrain = read.table("/Users/jiaodavy/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
xTrain = read.table("/Users/jiaodavy/UCI HAR Dataset/train/x_train.txt", header = FALSE)
yTrain = read.table("/Users/jiaodavy/UCI HAR Dataset/train/y_train.txt", header = FALSE)
colnames(activityType) = c("activity", "activityType")
colnames(subjectTrain) = "subject"
colnames(xTrain) = features[ , 2]
colnames(yTrain) = "activity"
trainingData = cbind(yTrain, subjectTrain, xTrain)

subjectTest = read.table("/Users/jiaodavy/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
xTest = read.table("/Users/jiaodavy/UCI HAR Dataset/test/x_test.txt", header = FALSE)
yTest = read.table("/Users/jiaodavy/UCI HAR Dataset/test/y_test.txt", header = FALSE)
colnames(subjectTest) = "subject"
colnames(xTest) = features[ , 2]
colnames(yTest) = "activity"
testData = cbind(yTest, subjectTest, xTest)

finalData = rbind(trainingData, testData)
colNames  = colnames(finalData)

logicalVector = (grepl("activity", colNames) | grepl("subject", colNames) | grepl("-mean", colNames) 
                 & !grepl("-meanFreq", colNames) & !grepl("mean..-", colNames) | grepl("-std..", colNames) 
                 & !grepl("-std()..-", colNames))
finalData = finalData[logicalVector == TRUE]

finalData = merge(finalData, activityType, by = "activity", all.x = TRUE)
colNames = colnames(finalData)

for (i in 1:length(colNames)) {
    colNames[i] = gsub("\\()", "", colNames[i])
    colNames[i] = gsub("-std$", "StdDev", colNames[i])
    colNames[i] = gsub("-mean", "Mean", colNames[i])
    colNames[i] = gsub("^(t)", "time", colNames[i])
    colNames[i] = gsub("^(f)", "freq", colNames[i])
    colNames[i] = gsub("([Gg]ravity)", "Gravity", colNames[i])
    colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)", "Body", colNames[i])
    colNames[i] = gsub("[Gg]yro","Gyro", colNames[i])
    colNames[i] = gsub("AccMag", "AccMagnitude", colNames[i])
    colNames[i] = gsub("([Bb]odyaccjerkmag)", "BodyAccJerkMagnitude", colNames[i])
    colNames[i] = gsub("JerkMag", "JerkMagnitude", colNames[i])
    colNames[i] = gsub("GyroMag", "GyroMagnitude", colNames[i])
}
colnames(finalData) = colNames

finalDataNoActivityType = finalData[ , names(finalData) != 'activityType']
tidyData = aggregate(finalDataNoActivityType[ , names(finalDataNoActivityType) != c("activity", "subject")],
                     by=list(activity=finalDataNoActivityType$activity, subject = finalDataNoActivityType$subject), mean)
tidyData = merge(tidyData, activityType, by="activity", all.x = TRUE)
write.table(tidyData, "/Users/jiaodavy/UCI HAR Dataset/tidyData.txt", row.names = TRUE, sep="\t")
