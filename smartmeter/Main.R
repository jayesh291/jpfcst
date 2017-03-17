rm(list = ls())


getwd()
# setwd()
source("libs.R")
source("dataset.R")
source("movingAverage.R")
source("weightedMovingAverage.R")
source("dailyPattern.R")
source("ratioPrevMA.R")

meterdata <- trained_data_set("./inputs/temp_dmd_data_daily_20170307.txt")
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
  dailyPatterns <- dailyPattern(tsMeterData,ma,noOfDaystoPredict)
  rdpwm <- ratioPrevMA(ma,dailyPatterns, noOfDaystoPredict)
  forecastData <- cbind(tsMeterData,ma,dailyPatterns,rdpwm)
  fc <- as.data.frame(forecastData)
  # mtrDataFileName <- paste0("./outs/validate_case1_",meterid,".csv")
  # write.csv(fc,file=mtrDataFileName)
#  Plot the graph with actual and predicted
  plot(0,0,xlim = c(1,length(fc$tsMeterData)),ylim = c(min(singleMeterData$val),max(singleMeterData$val)),type = "n",xlab = meterid)
  lines(fc$tsMeterData,type = 'l')
  lines(singleMeterData$val,type = 'l',col="blue")
  lines(fc$rdpwm,type = 'l', col = "red")
  # Forecast error calulation 
  # MAPE
  forecastError <- fc$tsMeterData[1:(length(fc$rdpwm)-8)]-fc$rdpwm[1:(length(fc$rdpwm)-8)]
  mapeForecastError <- abs(forecastError/fc$tsMeterData[1:(length(rdpwm)-8)]) * 100
  mapeForecastError[is.na(mapeForecastError)] <- 0.00001
  mapeForecastError[is.infinite(mapeForecastError)] <- 0.00001
  # sMAPE
  denominator <- abs(fc$rdpwm[1:(length(fc$rdpwm)-8)]+fc$tsMeterData[1:(length(fc$rdpwm)-8)])/2
  nmratr <- abs(fc$rdpwm[1:(length(fc$rdpwm)-8)]-fc$tsMeterData[1:(length(fc$rdpwm)-8)])
  smape = (1/7)* nmratr /denominator;
  datas <- cbindX(data.frame(fc$tsMeterData), data.frame(fc$rdpwm), data.frame(mapeForecastError),data.frame(smape))
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

