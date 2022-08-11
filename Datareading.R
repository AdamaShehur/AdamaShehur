setwd("C:/Users/shehu/Downloads/R script project")
#install.packages("caret")
#install.packages("shinythemes")
#install.packages("shinyWidgets")

data<- read.csv("Deprivation_LocalAuthority2.csv",header= TRUE)
names(data)
dim(data)

set.seed(12345)
samplefunction<- sample(2, nrow(data),replace=TRUE, prob=c(0.7,0.3))
samplefunction
datatrain<-data[samplefunction==1,]
datatest<-data[samplefunction==2,]
dim(datatrain)
dim(datatest)

names(datatrain)

