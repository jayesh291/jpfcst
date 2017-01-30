

source("ddfcst/libs.R")
source("ddfcst/constants.R")
source("ddfcst/dataset.R")
source("ddfcst/preprocess.R")
source("ddfcst/engine.R")
source("ddfcst/timeseriesProcessing.R")
source("ddfcst/plots.R")

# setwd("Desktop/ikl/delmon/git/jpfcst/")
# meterdata <- trained_data_set("temp_dmd_data_daily.txt")
# str(meterdata)
# plot_daily_meter_consumption(meterdata,daily_dmd_plot_filename)
# timeseriesData <- preprocess(meterdata)
# distanceMatrix <- distanceMatrixCorr(timeseriesData)
# numOfClust = 15
# tsHclust <- tsHclust(distanceMatrix, numOfClust = numOfClust)
# # timeseriesHclustUsingCorrelation(timeseriesData)
# head(timeseriesData)
# representiveTimeSeries <- representativeTimeSeries(tsHclust,timeseriesData,meterdata)
# head(representiveTimeSeries)
# #of clusters equals representativetimeseries
# str(unique(meterdata$id))

# windowSize=7
# stepSize=1
# i = 1
# meterid = "52D61DBC-595E-4E10-BA46-9EF4EE0650C2"
# mtr.id.data = meterdata[meterdata$id == meterid & meterdata$ts1 > "2016-11-26",]
# result <- getSlidingWindows(mtr.id.data, windowSize,i)
# print(result)

dissimilarity <- dtwDist(timeseries_meter_data)
distance <- as.dist(dissimilarity)
str(times) <- na.omit(timeseries_meter_data)
distance.matrix <- dist(times, method="DTW")
plot(hclust(distance.matrix))
distance.matrix
# distanceMatrix <- distanceMatrixCorr(timeseriesData)
# numOfClust = 15
# tsHclust <- tsHclust(distanceMatrix, numOfClust = numOfClust)

plot(dtw(timeseriesData[3,2],timeseriesData[2,],distance.only = TRUE))


## A noisy sine wave as query
idx<-seq(0,6.28,len=100);
query<-sin(idx)+runif(100)/10;

## A cosine is for template; sin and cos are offset by 25 samples
template<-cos(idx)

## Find the best match with the canonical recursion formula
library(dtw);
alignment<-dtw(query,template,keep=TRUE);

## Display the warping curve, i.e. the alignment curve
plot(alignment,type="threeway")
plot(
  dtw(query,template,keep=TRUE,
      step=rabinerJuangStepPattern(6,"c")),
  type="twoway",offset=-2);

## See the recursion relation, as formula and diagram
rabinerJuangStepPattern(6,"c")
plot(rabinerJuangStepPattern(6,"c"))

demo(dtw)
?dtw 

?plot.dtw

str(timeseriesData[2,])
ts1 <- na.omit(c(t(timeseriesData[10,-1])))
ts2 <- na.omit(c(t(timeseriesData[11,-1])))
ts3 <- na.omit(c(t(timeseriesData[11,-1])))
al <- dtw(ts3,ts2,keep=TRUE,step=asymmetric)
al$costMatrix
write.csv(file="costmatrix.csv",al$costMatrix)
plot(dist(al$costMatrix))
plot(ita,type="density",main="DTW")

par(mfrow=c(1,2))
plot(ts1,type="l")
plot(ts2,type="l",add=TRUE)

ggplot(df, aes(c(1:50))) +                  
  geom_line(aes(y=ts1), colour="red") +  
  geom_line(aes(y=ts2), colour="green")
l <- c()
l <- c(l,"1")
as.list(l)
points(ts1,ts2,col="RED");


dtwOmitNA <-function (x,y)
{
  a<-na.omit(x)
  b<-na.omit(y)
  return(dtw(a,b,distance.only=TRUE)$normalizedDistance)
}

## create a new entry in the registry with two aliases
pr_DB$set_entry(FUN = dtwOmitNA, names = c("dtwOmitNA"))
d<-dist(dataset, method = "dtwOmitNA") 
query
temp <- as.list(timeseriesData[2,])
colnames(timeseriesData[3,])
row.names(timeseriesData[3,])
c(t(timeseriesData[10,-1]))


corm <- cor(t(timeseriesData[1:6,16:20]), use = "pairwise.complete.obs", method = "pearson")
corm
# corm <-cor(t(timeseriesData),use = "pairwise.complete.obs",method = "pearson")
timeseriesData[1:16,16:20]
install.packages("apcluster")
library("apcluster")
datam
sim2 <- negDistMat(t(datam), r=2)
sim2

corm <- cor(datam, use = "pairwise.complete.obs", method = "pearson")
corm
corm <- cor(timeseriesData[1:6,16:20], use = "pairwise.complete.obs", method = "pearson")
sim2 <- negDistMat(timeseriesData,r=2)
apres <- apcluster(sim2)
show(apres)
plot(apres,data.frame(timeseriesData))
plot(apres, sim2)
apres


c1 <- c(0,1,2,3,4,5)
c1 [c1 == 0] <- 9  

ts.plot(timeseriesData[4:8,210:240])
matplot(t(timeseriesData[4:8,2:4]), type = "o")
