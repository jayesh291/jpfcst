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


# meterdata <- trained_data_set("./inputs/temp_dmd_data_daily_20170307.txt") -- old V1
meterdata <- trained_data_set("./inputs/daily_dmd_data_20170517.txt")

meterids <- unique(meterdata$id)
length(meterids)
filter_ids <- c("bdfa1158-4ab7-4f0d-9435-cb9be9fdebf9","b1de3a4a-2413-45bd-8fcf-749634b33368",
                "e930c633-ac33-40da-81d1-b5d374a93acf","75a448af-fc1c-44df-891b-8578d9745882")
meterids %in% c(filter_ids)
meterids <- subset(meterids, !(meterids %in% c(filter_ids)))

newMeterIds <- c()
cntr <- 1
insertCntr <- 1
while(cntr <= length(meterids)){
  meterid <- sample(meterids,1)
  # meterid <- "c3cd56b5-43fa-4753-a649-a8cf1f1bcf8b"
  meterid <- "f3523f2e-c5ff-4545-893b-0f3c335161e1"
  cntr <- cntr + 1
  singleMeterData <- meterdata[meterdata$id == meterid,]
  View(singleMeterData)
  if(sum(is.na(singleMeterData$val)) < 7){
    message(" id  ",meterid)
    newMeterIds[insertCntr] <- as.character(meterid) 
    insertCntr <- insertCntr + 1
  }
}
length(newMeterIds)

# meterid <- sample(meterids,1)
# meterid <- "FE7F4454-20F3-45E7-B3BF-959A6F0B6F57"
# meterid <- "0862C02E-73CA-4964-9661-6D783EF2DE7B"
# meterid <- "089FB058-CD33-41DD-9AFF-F00795122C6E"
# # meterid <- "0071CFB0−D92D−4035−ABA6−1AB961E4F573"
# meterid <- "FE7F4454-20F3-45E7-B3BF-959A6F0B6F57"
# meterid <- "3C5A1042−D1B2−4301−891D−5F9C66927280"
todaysDate <-format(Sys.time(), "%a%b%d%Y%H%S")

pdf(file=paste0("./outs/meters_",todaysDate,"_plot.pdf"))
# Time series cycle - for weekly pattern of daily data it is 7
cyclePeriod <- 7
# short it will be 1 period to cycle period
# medium will double the cycle period
# long will triple the cycle period
# meterids <- c("48DF03A1-4AE7-4729-A7F1-4853D74BEA44_FriMay1220171014","99381E39-CF2C-473E-BCE9-C49282B9D17F_FriMay1220171014")
longPrediction <- 3 
testcnt=length(meterids)
testcnt=300
i=1
error_summary <- c("id","mape")

# b1de3a4a-2413-45bd-8fcf-749634b33368  -- too many missing values

while(i <= testcnt){
  meterid <- sample(meterids,1)
  # meterid <- "3C5A1042-D1B2-4301-891D-5F9C66927280"
  message("Processing meter id - ",meterid)
  i <- i + 1
  singleMeterData <- meterdata[meterdata$id == meterid,]
  if(sum(is.na(singleMeterData$val)) > 7){
    message( " \t - ",meterid)
    next
  }
  if(nrow(singleMeterData) < 2 | length(singleMeterData) < 2 ){
    message(" Data is not valid !! Missing rows or columns")
    next
  }
    originalData <- singleMeterData
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
      meterid
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
      prediction$maxVector <- maxVector(tsMeterData,originalData$val,cyclePeriod)
      # prediction$maxVector
      prediction$normalization <- (prediction$dailyPattern*0.2/prediction$maxVector)+0.9
      # prediction$normalization
      prediction$basePrediction <- prediction$basevalue * prediction$normalization
      # prediction$basePrediction 
      # nPrediction <- apply(prediction$basePrediction,prediction$maxVector, function(x,y))
      nPrediction <- mapply(maxNormalization,prediction$basePrediction,prediction$maxVector)
      prediction$basePrediction <- nPrediction
      
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
    message(" y limits ",c(min(singleMeterData$prediction,na.rm = TRUE),max(singleMeterData$prediction, na.rm = TRUE)))
    ylimMin <- 0
    if( !is.infinite(min(singleMeterData$prediction,na.rm = TRUE))){
      ylimMin <- min(singleMeterData$prediction,na.rm = TRUE)
    }
    ylimMax <- 1
    if(!is.infinite(max(singleMeterData$prediction, na.rm = TRUE))){
      ylimMax <- max(singleMeterData$prediction, na.rm = TRUE)
    }
    
    write.csv(fc,file = paste0("./outs/",meterid,"_",todaysDate,".csv"))
    try(plot(0,0,xlim = c(1,length(tsMeterData)),ylim = c(ylimMin,ylimMax),type = "n",xlab = meterid))
    historicalData <- meterdata[meterdata$id == meterid,]
    lines(historicalData$val,type = 'l',col="blue")
    lines(singleMeterData$prediction,type = 'l', col = "red")
    lines(singleMeterData$basePrediction,type = 'l', col = "green")
  
    abs_error <- abs(as.numeric(singleMeterData$val) - as.numeric(singleMeterData$prediction))/(as.numeric(singleMeterData$val))
    mape <- sum(abs_error,na.rm = TRUE)*100/nrow(singleMeterData)
    mape
    error_summary <- rbind(error_summary,c(as.character(meterid),as.numeric(mape)))
}

write.csv(file = paste0("./outs/error_summary",todaysDate,".csv"),error_summary)
dev.off()
