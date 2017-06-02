rm(list = ls())


getwd()
setwd("smartmeter/")
source("libs.R")
source("dataset.R")
source("basevalue.R")
source("movingAverage.R")
source("dailyPattern.R")
source("ratioPrevMA.R")
library(gdata)

meterdata <- trained_data_set("./inputs/daily_dmd_data_20170517.txt")
meterids <- unique(meterdata$id)
meterid <- sample(meterids,1)
meterid <- "150EBA46-26EB-4E0C-A6B9-5BE5043CCD61"
todaysDate <-format(Sys.time(), "%a%b%d%Y%H%S")
pdf(file=paste0("./outs/fctplot",todaysDate,".pdf"))
errorSummary <- c()
noOfDaystoPredict <- 7
for(meterid in meterids){
  testcnt=1
  i=1
  if(i > testcnt){
    break
  }
  testcnt <- testcnt + 1
  singleMeterData <- meterdata[meterdata$id == meterid,]
  singleMeterData[is.na(singleMeterData)] <- 0
  
  countr = 1;
  while(countr < 3){
    countr <- countr + 1
    tsMeterData <- singleMeterData$val
    ma <- movingAverage(tsMeterData,noOfDaystoPredict)
    if(countr ==1){
      nextDay <- format(as.Date(singleMeterData[nrow(singleMeterData)-1,c("ts1")])+2,"%Y-%m-%d")
      singleMeterData <- rbind(singleMeterData,c(meterid,nextDay,0,nextDay)) 
      
    }else{
      nextDay <- format(as.Date(singleMeterData[nrow(singleMeterData)-1,c("ts1")])+2,"%Y-%m-%d")
      singleMeterData <- rbind(singleMeterData,c(meterid,nextDay,0,nextDay,)) 
    }
    singleMeterData$ma <- ma
    # Need to handle spike and vally's
    baseValue <- basevalue(tsMeterData,noOfDaystoPredict)
    singleMeterData$baseValue <- baseValue
    dailyPatterns <- dailyPattern(tsMeterData,ma,noOfDaystoPredict)
    length(dailyPatterns)
    singleMeterData$dailyPattern <- dailyPatterns
    trend <- ratioPrevMA(ma,dailyPatterns, noOfDaystoPredict)
    singleMeterData$trend <- trend
    prediction <- baseValue*dailyPatterns*trend
    singleMeterData$pred <- prediction
    singleMeterData[nrow(singleMeterData),"val"]<- prediction[length(prediction)]
    # appendSingleMeterData <- 
    str(singleMeterData)
    # write.csv(singleMeterData,file = paste0("./outs/",meterid,"_",todaysDate,".csv"))
    
  }
  str(singleMeterData)
  write.csv(singleMeterData,file = paste0("./outs/",meterid,"_",todaysDate,".csv"))
  
  forecastData <- cbind(tsMeterData,prediction)
  fc <- as.data.frame(forecastData)
  #  Plot the graph with actual and predicted
  plot(0,0,xlim = c(1,length(fc$tsMeterData)),ylim = c(min(singleMeterData$val),max(singleMeterData$val)),type = "n",xlab = meterid)
  lines(fc$tsMeterData,type = 'l')
  lines(singleMeterData$val[1:(length(tsMeterData)-noOfDaystoPredict)],type = 'l',col="blue")
  lines(fc$prediction,type = 'l', col = "red")
  # Forecast error calulation 
  # MAPE
  # write.csv(singleMeterData,file=paste0("./outs/",meterid,"_steps.csv"))
  forecastError <- fc$tsMeterData[1:(length(fc$prediction)-8)]-fc$prediction[1:(length(fc$prediction)-8)]
  mapeForecastError <- abs(forecastError/fc$tsMeterData[1:(length(trend)-8)]) * 100
  mapeForecastError[is.na(mapeForecastError)] <- 0.00001
  mapeForecastError[is.infinite(mapeForecastError)] <- 0.00001
  # sMAPE
  denominator <- abs(fc$prediction[1:(length(fc$prediction)-8)]+fc$tsMeterData[1:(length(fc$prediction)-8)])/2
  nmratr <- abs(fc$prediction[1:(length(fc$prediction)-8)]-fc$tsMeterData[1:(length(fc$prediction)-8)])
  smape = (1/7)* nmratr /denominator;
  datas <- cbindX(data.frame(fc$tsMeterData), data.frame(fc$prediction), data.frame(mapeForecastError),data.frame(smape))
  df.fc <- as.data.frame(datas)
  # Forecast error : Average of MAPE
  mapeMean=mean(mapeForecastError[length(mapeForecastError)-15:(length(mapeForecastError)-8)])
  errorSummary <- c(errorSummary,mapeMean)
  fileName <- paste0("./outs/",meterid,"mape_",mapeMean,"_",todaysDate,".csv")
  # write.csv(df.fc,file=fileName)
}
# Create errorSummary for the forecast and save in csv
mtr.data <- c()
mtr.data$ids <- unique(meterdata$id)
mtr.data$errorSummary <- errorSummary
mtr.data.df <- as.data.frame(mtr.data)
mtr.data.srt <- mtr.data.df[order(errorSummary),]
write.csv(mtr.data.srt, file=paste0("./outs/errorSummary",todaysDate,".csv"))
# quantile(errorSummary)
# off the graphics 
dev.off()





