library(xts)


source("ddfcst/libs.R")
source("ddfcst/constants.R")
source("ddfcst/dataset.R")
source("ddfcst/datapreprocess.R")
source("ddfcst/engine.R")
source("ddfcst/timeseriesProcessing.R")
source("ddfcst/plots.R")
source("ddfcst/forecast.R")

#   meterdata <- trained_data_set("temp_dmd_data_daily.txt")
# str(meterdata)
# plot_daily_meter_consumption(meterdata,daily_dmd_plot_filename)
timeseriesData <- preprocess(meterdata)
# distanceMatrix <- distanceMatrixCorr(timeseriesData)
# numOfClust = 15
# tsHclust <- tsHclust(distanceMatrix, numOfClust = numOfClust)
# # timeseriesHclustUsingCorrelation(timeseriesData)
# head(timeseriesData)
# representiveTimeSeries <- representativeTimeSeries(tsHclust,timeseriesData,meterdata)
# head(representiveTimeSeries)
# #of clusters equals representativetimeseries
# str(unique(meterdata$id))


windowSize=7
stepSize=1
i = 1
meterids <- unique(meterdata$id)
meterid <- sample(meterids,1)
meterid
mtr.id.data = meterdata[meterdata$id == meterid & meterdata$ts1 > "2016-11-26",]
filename <- paste0("slidingwindow",meterid,".csv")
write.csv(file = filename,mtr.id.data)
result <- getSlidingWindows(mtr.id.data, windowSize,i)
print(result)
fileNm <- paste0("Result_slidingwindow",meterid,".csv")
write.csv(file = fileNm,result)
# dissimilarity <- dtwDist(timeseries_meter_data)
# distance <- as.dist(dissimilarity)
# str(times) <- na.omit(timeseries_meter_data)
# distance.matrix <- dist(times, method="DTW")
# plot(hclust(distance.matrix))
# distance.matrix
# distanceMatrix <- distanceMatrixCorr(timeseriesData)
# numOfClust = 15
# tsHclust <- tsHclust(distanceMatrix, numOfClust = numOfClust)



nrow(meterdata)
head(timeseriesData)
unique(timeseriesData$id)
meterids <- unique(timeseriesData$id)

source("ddfcst/closenessBetweenTimeSeries.R")
clm <- matrix(NA,nrow=length(meterids),ncol=length(meterids),byrow=T)
# for (id in meterids) {
id <- "F72C29B2-A75A-40EA-BA95-01B53F26D726"
ts1 <- timeseriesData[timeseriesData$id==id,];
# print(ts1[2:ncol(ts1),])
ts1 [is.na(ts1)] <- 0
ts2 <- ts1[,2:ncol(ts1)] 
closeness <- closenessBetweenTimeSeries(ts2,ts2)  
print(closeness)



fixedSeriesSum <- sum(ts2);
compareSeriesSum <- sum(ts2);
totalSeries <- ts2 + ts2;
totalSeriesSum <- sum(totalSeries);
P <- fixedSeriesSum / totalSeriesSum;
sqrtPP <- sqrt(P * (1-P));
sqrtTotalSeries = sqrt(totalSeries);
errorC <- ((P * totalSeries) - ts2) / (sqrtTotalSeries * sqrtPP);
numeratorElements <- (errorC ^ 2 ) / sqrtTotalSeries;
numerator <- sum(numeratorElements);
denominator <- sum(sqrtTotalSeries);
#print(numerator / denominator);
closeness <- sqrt(numerator / denominator);
print(closeness);





# 30th Jan

nrow(meterdata)
length(meterids)
meterid  <- sample(meterids,1)
meterid
singleMeterId <- meterdata[meterdata$id == meterid,]  
# xts
tsSingleMeter <- xts(singleMeterId$val,order.by=singleMeterId$ts1)
# tsSingleMeter <- ts(singleMeterId$val,start = c(2016,8),frequency = )
ts.ts <- ts(tsSingleMeter,start = c(2016,12),frequency = 365)
training <- window(ts.ts,end=c(2016,90))
testing <- window(ts.ts,start = c(2016,90),end=c(2016,106))
faa <- forecast(ets(training),h=16)
plot(faa, main = "Prediction")
lines(testing, col = "red")
faa$fitted

# ts



plotForecastedMeters(meterdata)






sSS <- scale(tsSingleMeterTS,scale = FALSE)
# tsSingleMeterTS.norma
m_aa = auto.arima(trainingTS)
f_aa = forecast(m_aa, h=24)
plot(f_aa)
lines(testingTS, col = "red")

m_tbats = tbats(trainingTS)
f_tbats = forecast(m_tbats, h=24)
plot(f_tbats)
lines(testingTS, col = "red")

trends <- decompose(tsSingleMeterTS, type = c("additive","multiplicative"),filter = NULL)
plot(trends)



faa <- forecast(training)
training <- window(tsSingleMeter,start=c(2016,08),end=c(2016,12))
testing <- window(tsSingleMeter,start = c(2016,12))
plot(tsSingleMeter)
forecastTS <- forecast(tsSingleMeter,h=6)
plot(forecastTS)
plot(singleMeterId$val, type='l')
Q.z <- zoo(meterdata$val, order.by=meterdata$ts1)
head(Q.z)
head(singleMeterId)
head(tsSingleMeter)
plot(Q.z)
str(Q.z)

# Use msts objects to encode time series with multiple seasonalities:
msts(data[,1],seasonal.periods=c(48,7*48))
# You can then fit models with multiple seasonalities using tbats:
tbats(msts(data[,1],seasonal.periods=c(48,7*48)))


