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
library(gdata)

meterdata <- trained_data_set("./inputs/temp_dmd_data_daily_20170307.txt")
meterids <- unique(meterdata$id)
meterid <- sample(meterids,1)
meterid <- "FE7F4454-20F3-45E7-B3BF-959A6F0B6F57"
meterid <- "0862C02E-73CA-4964-9661-6D783EF2DE7B"
meterid <- "089FB058-CD33-41DD-9AFF-F00795122C6E"
# meterid <- "0071CFB0−D92D−4035−ABA6−1AB961E4F573"
meterid <- "FE7F4454-20F3-45E7-B3BF-959A6F0B6F57"
todaysDate <-format(Sys.time(), "%a%b%d%Y%H%S")
cyclePeriod <- 7
timeOfPrediction <- 3 
# for(meterid in meterids){
  testcnt=1
  i=1
  if(i > testcnt){
    break
  }
  testcnt <- testcnt + 1
  singleMeterData <- meterdata[meterdata$id == meterid,]
  singleMeterData[is.na(singleMeterData)] <- 0
  if(is.na(singleMeterData)){
    message(" Please check missing data !!! ")
  }
  countr = 1;
  # while(countr < 3){
    countr <- countr + 1
    tsMeterData <- singleMeterData$val
    if(countr ==1){
      nextDay <- format(as.Date(singleMeterData[nrow(singleMeterData)-1,c("ts1")])+2,"%Y-%m-%d")
      singleMeterData <- rbind(singleMeterData,c(meterid,nextDay,0,nextDay))
    }else{
      nextDay <- format(as.Date(singleMeterData[nrow(singleMeterData)-1,c("ts1")])+2,"%Y-%m-%d")
      singleMeterData <- rbind(singleMeterData,c(meterid,nextDay,0,nextDay))
    }
    tsMeterData[length(tsMeterData)+1] <- 0
    if(length(tsMeterData) != length(singleMeterData$val)){
      message(" Please check - Need to add row in tsMeterData !")
    }
    # For long prediction change it from 1 to number of periods i.e. for daily data
    # weekly pattern, so only 3 weeks previous data could work. We can range it from 2,3 and 4 for month.
    prediction <- {}
    prediction$basevalue <- basevalueForLongPrediction(tsMeterData,cyclePeriod,timeOfPrediction)
    prediction$movingAverage <- movingAverage(tsMeterData,cyclePeriod)
    prediction$movingAverage
    prediction$dailyPattern <- dailyPattern(tsMeterData,prediction$movingAverage,cyclePeriod)
    prediction$dailyPattern
    prediction$maxVector <- maxVector(tsMeterData)
    prediction$maxVector
    prediction$normalization <- (prediction$dailyPattern*0.2/prediction$maxVector)+0.9
    prediction$normalization
    prediction$basePrediction <- prediction$basevalue * prediction$normalization
    prediction$basePrediction 
    prediction$minVector <- minVector(prediction$basePrediction,cyclePeriod)
    prediction$minVector
    prediction$minValueWeeklyTrend <- minValueWeeklyTrend(prediction$minVector)
    prediction$minValueWeeklyTrend
    prediction$avgMinValues <- minValueAvg(prediction$minValueWeeklyTrend)
    prediction$avgMinValues
    prediction$prediction <- prediction$basePrediction*prediction$avgMinValues
    prediction$prediction
    prediction <- as.data.frame(prediction)
    str(prediction)
    forecastData <- cbind(singleMeterData,prediction)
    fc <- as.data.frame(forecastData)
    write.csv(fc,file = paste0("./outs/",meterid,"_",todaysDate,".csv"))
    plot(0,0,xlim = c(1,length(tsMeterData)),ylim = c(min(tsMeterData),max(tsMeterData)),type = "n",xlab = meterid)
    lines(tsMeterData,type = 'l')
    lines(singleMeterData$val,type = 'l',col="blue")
    lines(singleMeterData$prediction,type = 'l', col = "red")
  # }
  # str(singleMeterData)
  # write.csv(singleMeterData,file = paste0("./outs/",meterid,"_",todaysDate,".csv"))
  # forecastData <- cbind(tsMeterData,prediction)
  # fc <- as.data.frame(forecastData)
  # #  Plot the graph with actual and predicted
  # plot(0,0,xlim = c(1,length(fc$tsMeterData)),ylim = c(min(singleMeterData$val),max(singleMeterData$val)),type = "n",xlab = meterid)
  # lines(fc$tsMeterData,type = 'l')
  # lines(singleMeterData$val[1:(length(tsMeterData)-cyclePeriod)],type = 'l',col="blue")
  # lines(fc$prediction,type = 'l', col = "red")
# }





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




