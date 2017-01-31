
forecastedMeters <- function(meterdata){
  pdf(file="./outs/forecastplot_arima.pdf")
  for(meterid in meterids){
    singleMeterId <- meterdata[meterdata$id == meterid,] 
    if(sd(singleMeterId$val) > 0) {
      tsSingleMeterTS <- ts(singleMeterId$val,start=c(2016,as.POSIXlt("2016-08-26")$yday+1),frequency=365)
      startYear <- start(tsSingleMeterTS)[1]
      startMonth <- start(tsSingleMeterTS)[2]
      endYear <- end(tsSingleMeterTS)[1]
      endMonth <- end(tsSingleMeterTS)[2]
      predictionPercent <- 20
      predictionInterval <- ifelse(startYear == endYear,((endMonth-startMonth)*predictionPercent/100),(endMonth-predictionPercent))
      paste0(meterid," ", startYear ," - ",startMonth, " ", endYear , " - ", endMonth)
      trainingTS <- window(tsSingleMeterTS,end=c(endYear,endMonth-predictionInterval))
      if(sd(trainingTS) > 0){
        testingTS <- window(tsSingleMeterTS,start = c(endYear,endMonth-predictionInterval),end=c(endYear,endMonth))
        
        aarima <- try(auto.arima(trainingTS))
        if(inherits(aarima, "try-error"))
        {
          message(" ID  ", meterid)
        }
        faaTS <- forecast(aarima,h=12)
        plot(faaTS, main = "Prediction")
        lines(testingTS, col = "red")
      }
    }
  }
  dev.off()
}
# plotForecastedMeters(meterdata)


