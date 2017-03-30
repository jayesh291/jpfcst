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

meterdata <- trained_data_set("./inputs/daily_dmd_data_20170327.txt")
meterids <- unique(meterdata$id)
meterid <- sample(meterids,1)
todaysDate <-format(Sys.time(), "%a%b%d%Y")
pdf(file=paste0("./outs/fctplot",todaysDate,".pdf"))
errorSummary <- c()
noOfDaystoPredict <- 7
for(meterid in meterids){
  
  
  singleMeterData <- meterdata[meterdata$id == meterid,]
  singleMeterData[is.na(singleMeterData)] <- 0
  tsMeterData <- singleMeterData$val
  ma <- movingAverage(tsMeterData,noOfDaystoPredict)
  singleMeterData$ma <- ma
  baseValue <- basevalue(tsMeterData,noOfDaystoPredict)
  singleMeterData$baseValue <- baseValue
  dailyPatterns <- dailyPattern(ma,noOfDaystoPredict)
  singleMeterData$dailyPattern <- dailyPatterns
  trend <- ratioPrevMA(ma,dailyPatterns, noOfDaystoPredict)
  singleMeterData$trend <- trend
  prediction <- baseValue*dailyPatterns*trend
  
  singleMeterData$pred <- prediction
  # write.csv(singleMeterData,file = paste0("./outs/",meterid,".csv"))
  forecastData <- cbind(tsMeterData,prediction)
  fc <- as.data.frame(forecastData)
#  Plot the graph with actual and predicted
  plot(0,0,xlim = c(1,length(fc$tsMeterData)),ylim = c(min(singleMeterData$val),max(singleMeterData$val)),type = "n",xlab = meterid)
  lines(fc$tsMeterData,type = 'l')
  lines(singleMeterData$val[1:(length(tsMeterData)-noOfDaystoPredict)],type = 'l',col="blue")
  lines(fc$prediction,type = 'l', col = "red")
  # Forecast error calulation 
  # MAPE
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
  write.csv(df.fc,file=fileName)
}
# Create errorSummary for the forecast and save in csv
mtr.data <- c()
mtr.data$ids <- unique(meterdata$id)
mtr.data$errorSummary <- errorSummary
mtr.data.df <- as.data.frame(unique(meterdata$id),errorSummary)
mtr.data.srt <- mtr.data.df[order(errorSummary),]
write.csv(mtr.data.srt, file=paste0("./outs/errorSummary",todaysDate,".csv"))
# off the graphics 
dev.off()

