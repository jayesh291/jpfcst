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
# exceptional ids
filter_ids <- c("25e88ffc-cdd0-410d-a212-7b1ddf5fe041","2fb9f4c6-cab3-4a81-b16d-94f16aeada35",
                "46b801c9-eac3-46de-bc7c-9b0f0f600d9f","a51a414b-d84d-4201-b60c-167d16ce55b2",
                "0071cfb0-d92d-4035-aba6-1ab961e4f573","0114170c-47be-4b74-ae94-b90f39f8fc99",
                "47f10256-12ab-4aa3-af21-d490a54d403d")
which(meterids %in% c("a51a414b-d84d-4201-b60c-167d16ce55b2"))

meterids <- subset(meterids, !(meterids %in% c(filter_ids)))

length(meterids)
# meterids <- meterids[1:length(meterids)]

todaysDate <-format(Sys.time(), "%a%b%d%Y%H%S")
pdf(file=paste0("./outs/meters_",todaysDate,"_plot.pdf"))

# Time series cycle - for weekly pattern of daily data it is 7
cyclePeriod <- 7

# short it will be 1 period to cycle period
# medium will double the cycle period
# long will triple the cycle period
longPrediction = 3

numOfMetersToProcess = length(meterids)
numOfMetersToProcess=30
numOfDaysToForecast = 90

error_summary <- c("id","mape")

# Looping for all meters 
for(i in 1:numOfMetersToProcess){
  
  # Random pick one id from list
  meterid <- meterids[i]
  message("Processing meter id - ",meterid)
  
  singleMeterData <- meterdata[meterdata$id == meterid,]
  if(nrow(singleMeterData) < 2 | length(singleMeterData) < 2 ){
    message(" Data is not valid !! Missing rows or columns")
    next
  }
  
  originalData <- singleMeterData

  # Outlier detection and replacements: Detect the outliers and remove those rows. Consider
  # it as missing information.
  try(outlierTSO <- tso(ts(singleMeterData$val),delta = 0.7,types = c("LS")))
  # nrow(outlierTSO$outliers)
  message("For ",meterid,", # of rows ",nrow(outlierTSO$outliers))
  if(nrow(outlierTSO$outliers) > 0){
    singleMeterData <- singleMeterData[-c(outlierTSO$outliers$ind),]
  }

  # Adding only dates for missing days 
  singleMeterData <- addMissingDates(data = singleMeterData, "ts1")
  singleMeterData$val <- as.numeric(singleMeterData$val)
  
  # missing value will be replaced by 7 days before or after when missing element is at start
  singleMeterData$val <- imputeFromNumOfDaysBefore(singleMeterData$val,7) 
  indx <- apply(singleMeterData, 2, function(x) any(is.na(x) | is.infinite(x)))
  if(TRUE %in% indx){
    message(" Please check missing data !!! ")
  }
  
  originalData.imputed <- singleMeterData$val
  
  countr = 0;
  while(countr < numOfDaysToForecast){
    countr <- countr + 1
    meterid
    singleMeterData <- singleMeterData[,c("id","ts","val","ts1")]
    tsMeterData <-as.numeric(singleMeterData$val)
    
    nextDay <- format(as.Date(singleMeterData[nrow(singleMeterData)-1,c("ts1")])+2,"%Y-%m-%d")
    singleMeterData <- rbind(singleMeterData,c(meterid,nextDay,0,nextDay))
    # nrow(singleMeterData)
    tsMeterData[length(tsMeterData)+1] <- 0
    if(length(tsMeterData) != length(singleMeterData$val)){
      message(" Please check - Need to add row in tsMeterData !")
    }

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
  
  numOfDays = length(originalData.imputed)
  ignoreTop = ceiling(numOfDays*30/100)
  
  singleMeterData$prediction[is.na(singleMeterData$prediction)] <- 0
  singleMeterData$prediction[is.nan(singleMeterData$prediction)] <- 0
  singleMeterData$prediction[is.infinite(singleMeterData$prediction)] <- 0
  
  message(" y limits ",c(min(singleMeterData$prediction,na.rm = TRUE),max(singleMeterData$prediction, na.rm = TRUE)))
  ylimMin <- 0
  if( !is.infinite(min(singleMeterData$prediction,na.rm = TRUE))){
    ylimMin <- min(singleMeterData$prediction[ignoreTop:length(singleMeterData$prediction)],na.rm = TRUE)
  }
  ylimMax <- 1
  if(!is.infinite(max(singleMeterData$prediction, na.rm = TRUE))){
    ylimMax <- max(singleMeterData$prediction[ignoreTop:length(singleMeterData$prediction)], na.rm = TRUE)
  }
  
  write.csv(fc,file = paste0("./outs/",meterid,"_",todaysDate,".csv"))
  try(plot(0,0,xlim = c(1,length(tsMeterData)),ylim = c(ylimMin,ylimMax),type = "n",xlab = meterid))
  historicalData <- meterdata[meterdata$id == meterid,]
  lines(historicalData$val[ignoreTop:length(historicalData$val)],type = 'l',col="blue")
  lines(singleMeterData$prediction[ignoreTop:length(singleMeterData$prediction)],type = 'l', col = "red")
  # lines(singleMeterData$basePrediction,type = 'l', col = "green")
  
  
  abs_error <- abs(as.numeric(singleMeterData$val[ignoreTop:numOfDays]) - as.numeric(singleMeterData$prediction[ignoreTop:numOfDays]))/(as.numeric(singleMeterData$val[ignoreTop:numOfDays]))
  mape <- sum(abs_error,na.rm = TRUE)*100/numOfDays
  mape
  error_summary <- rbind(error_summary,c(as.character(meterid),as.numeric(mape)))
}

write.csv(file = paste0("./outs/error_summary",todaysDate,".csv"),error_summary)
dev.off()
# graphics.off()

