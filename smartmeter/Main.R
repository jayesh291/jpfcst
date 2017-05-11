rm(list = ls())



getwd()
setwd("smartmeter/")
source("libs.R")
source("dataset.R")
source("basevalue.R")
source("dailyPattern.R")
source("ratioPrevMA.R")
source("movingAverage.R")
source("normalization.R")
source("scaleFactor.R")
source("datesUtil.R")
source("timeseriesImpute.R")


meterdata <- trained_data_set("./inputs/temp_dmd_data_daily_20170307.txt")
meterids <- unique(meterdata$id)

# meterid <- sample(meterids,1)
# meterid <- "FE7F4454-20F3-45E7-B3BF-959A6F0B6F57"
# meterid <- "0862C02E-73CA-4964-9661-6D783EF2DE7B"
# meterid <- "089FB058-CD33-41DD-9AFF-F00795122C6E"
# # meterid <- "0071CFB0−D92D−4035−ABA6−1AB961E4F573"
# meterid <- "FE7F4454-20F3-45E7-B3BF-959A6F0B6F57"
todaysDate <-format(Sys.time(), "%a%b%d%Y%H%S")

pdf(file=paste0("./outs/meters_",todaysDate,"_plot.pdf"))
# Time series cycle - for weekly pattern of daily data it is 7
cyclePeriod <- 7
# short it will be 1 period to cycle period
# medium will double the cycle period
# long will triple the cycle period

longPrediction <- 3 
testcnt=length(meterids)
testcnt=5
i=1
while(i < testcnt){
  meterid <- sample(meterids,1)
  # meterid <- "8F27FE8C-878C-42F8-A9A1-F0B17A54442D"
  message("Processing meter id - ",meterid)
  i <- i + 1
  singleMeterData <- meterdata[meterdata$id == meterid,]
  singleMeterData <- addMissingDates(data = singleMeterData, "ts1")
  singleMeterData$val <- as.numeric(singleMeterData$val)
  # missing value will be replaced by 7 days before or after when missing element is at start
  # singleMeterData$val <- imputeFromNumOfDaysBefore(singleMeterData$val,7) 
  singleMeterData$val <- imputeFromNumOfDaysBefore(singleMeterData$val,7) 
  indx <- apply(singleMeterData, 2, function(x) any(is.na(x) | is.infinite(x)))
  if(TRUE %in% indx){
    message(" Please check missing data !!! ")
  }
  countr = 0;
  while(countr < 100){
    countr <- countr + 1
    singleMeterData <- singleMeterData[,c("id","ts","val","ts1")]
    tsMeterData <-as.numeric(singleMeterData$val)
    # str(tsMeterData)
    if(countr ==1){
      nextDay <- format(as.Date(singleMeterData[nrow(singleMeterData)-1,c("ts1")])+2,"%Y-%m-%d")
      singleMeterData <- rbind(singleMeterData,c(meterid,nextDay,0,nextDay))
    }else{
      nextDay <- format(as.Date(singleMeterData[nrow(singleMeterData)-1,c("ts1")])+2,"%Y-%m-%d")
      singleMeterData <- rbind(singleMeterData,c(meterid,nextDay,0,nextDay))
    }
    # nrow(singleMeterData)
    tsMeterData[length(tsMeterData)+1] <- 0
    if(length(tsMeterData) != length(singleMeterData$val)){
      message(" Please check - Need to add row in tsMeterData !")
    }
    # For long prediction change it from 1 to number of periods i.e. for daily data
    # weekly pattern, so only 3 weeks previous data could work. We can range it from 2,3 and 4 for month.
    prediction <- {}
    prediction$basevalue <- basevalueForLongPrediction(tsMeterData,cyclePeriod,longPrediction)
    prediction$movingAverage <- movingAverage(tsMeterData,cyclePeriod)
    # prediction$movingAverage
    prediction$dailyPattern <- dailyPattern(tsMeterData,prediction$movingAverage,cyclePeriod)
    # prediction$dailyPattern
    prediction$maxVector <- maxVector(tsMeterData)
    # prediction$maxVector
    prediction$normalization <- (prediction$dailyPattern*0.2/prediction$maxVector)+0.9
    # prediction$normalization
    prediction$basePrediction <- prediction$basevalue * prediction$normalization
    # prediction$basePrediction 
    prediction$minVector <- minVector(prediction$basePrediction,cyclePeriod)
    # prediction$minVector
    prediction$minValueWeeklyTrend <- minValueWeeklyTrend(prediction$minVector)
    # prediction$minValueWeeklyTrend
    prediction$avgMinValues <- minValueAvg(prediction$minValueWeeklyTrend)
    # prediction$avgMinValues
    prediction$prediction <- prediction$basePrediction*prediction$avgMinValues
    # prediction$prediction
    prediction <- as.data.frame(prediction)
    nextDay <- format(as.Date(singleMeterData[nrow(singleMeterData),c("ts1")])+2,"%Y-%m-%d")
    singleMeterData <- rbind(singleMeterData,c(meterid,as.character(nextDay),0,nextDay))
    forecastData <- cbind(singleMeterData,prediction)
    # str(forecastData)
    forecastData$val[length(forecastData$val)] <- forecastData$basePrediction[length(forecastData$val)-1]
    forecastData$id[length(forecastData$val)] <- meterid
    forecastData$ts <- forecastData$ts1
    fc <- as.data.frame(forecastData)
    fc <- fc[-(nrow(fc)-1),]
    singleMeterData <- fc
  }
  
  
  write.csv(fc,file = paste0("./outs/",meterid,"_",todaysDate,".csv"))
  try(plot(0,0,xlim = c(1,length(tsMeterData)),ylim = c(min(tsMeterData),max(tsMeterData)),type = "n",xlab = meterid))
  historicalData <- meterdata[meterdata$id == meterid,]
  lines(historicalData$val,type = 'l',col="blue")
  lines(singleMeterData$prediction,type = 'l', col = "red")
  
}

dev.off()

  
  # missing dates impute:
singleMeterData <- meterdata[meterdata$id == meterid,]
nrow(singleMeterData)
plot(singleMeterData$val,type="l")
retrivedSMD <- addMissingDates(singleMeterData, "ts1")
nrow(retrivedSMD)

singleMeterData$val <- as.numeric(singleMeterData$val)
# acf(singleMeterData$val)
# rm(addMissingDates)
source("datesUtil.R")
retrivedSMD <- addMissingDates(data = singleMeterData, "ts1")
nrow(retrivedSMD)
View(retrivedSMD)


#  Impute values for the missing dates
df <- retrivedSMD
colnames(df)

# using hmisc package
str(df)
df$val <- as.numeric(df$val)
df$val <- with(df, impute(val, mean))
df$val

# using imputeTS package
df <- retrivedSMD
df$val <- as.numeric(df$val)
simple <- na.ma(df$val, k = 7, weighting = "simple")
linear <- na.ma(df$val, k = 7, weighting = "linear")
expon <- na.ma(df$val, k = 7, weighting = "exponential")
# Plots
par(mfrow=c(1,2))
plot(0,0,xlim = c(1,length(df$val)),ylim = c(min(df$val,na.rm = TRUE),max(df$val,na.rm = TRUE)),type = "n",xlab = meterid)
lines(simple,type = 'l',col="blue")
lines(linear,type = 'l', col = "red")
lines(expon,type = 'l', col = "green")
lines(df$val,type = 'l', col = "orange")
par(mfrow=c(1,1))


# Customized impute
rm(imputeFromNumOfDaysBefore)
source("timeseriesImpute.R")
df <- retrivedSMD
sevanDays <- imputeFromNumOfDaysBefore(df$val,7)
# df$val <- sevanDays
twoWeeks <- imputeFromNumOfDaysBefore(df$val,14)
# df$val <- twoWeeks
df$val <- as.numeric(df$val)
plot(0,0,xlim = c(1,length(df$val)),ylim = c(min(df$val,na.rm = TRUE),max(df$val,na.rm = TRUE)),type = "n",xlab = meterid)
lines(df$val,type = 'l',col="blue")
lines(sevanDays,type = 'l', col = "red")
lines(twoWeeks,type = 'l', col = "green")

# write.csv(file = "./outs/df1.csv",df)

install.packages("mi")
library(mi)
df <- retrivedSMD
df$val <- as.numeric(df$val)
mdf <- missing_data.frame(df[,c(-4)])
mdf
mia <- mi(mdf)






# # Forecast error calulation 
# # MAPE
# # write.csv(singleMeterData,file=paste0("./outs/",meterid,"_steps.csv"))
# forecastError <- fc$tsMeterData[1:(length(fc$prediction)-8)]-fc$prediction[1:(length(fc$prediction)-8)]
# mapeForecastError <- abs(forecastError/fc$tsMeterData[1:(length(trend)-8)]) * 100
# mapeForecastError[is.na(mapeForecastError)] <- 0.00001
# mapeForecastError[is.infinite(mapeForecastError)] <- 0.00001
# # sMAPE
# denominator <- abs(fc$prediction[1:(length(fc$prediction)-8)]+fc$tsMeterData[1:(length(fc$prediction)-8)])/2
# nmratr <- abs(fc$prediction[1:(length(fc$prediction)-8)]-fc$tsMeterData[1:(length(fc$prediction)-8)])
# smape = (1/7)* nmratr /denominator;
# datas <- cbindX(data.frame(fc$tsMeterData), data.frame(fc$prediction), data.frame(mapeForecastError),data.frame(smape))
# df.fc <- as.data.frame(datas)
# # Forecast error : Average of MAPE
# mapeMean=mean(mapeForecastError[length(mapeForecastError)-15:(length(mapeForecastError)-8)])
# errorSummary <- c(errorSummary,mapeMean)
# fileName <- paste0("./outs/",meterid,"mape_",mapeMean,"_",todaysDate,".csv")
# # write.csv(df.fc,file=fileName)
# Create errorSummary for the forecast and save in csv
# mtr.data <- c()
# mtr.data$ids <- unique(meterdata$id)
# mtr.data$errorSummary <- errorSummary
# mtr.data.df <- as.data.frame(mtr.data)
# mtr.data.srt <- mtr.data.df[order(errorSummary),]
# write.csv(mtr.data.srt, file=paste0("./outs/errorSummary",todaysDate,".csv"))
# # quantile(errorSummary)
# # off the graphics 
# dev.off()
# 




