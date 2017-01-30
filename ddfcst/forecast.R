plotForecastedMeters <- function(meterdata) {
  meterids <- unique(meterdata$id)
  pdf(file = "./outs/forecastplot.pdf")
  for(meterid in meterids){
    singleMeterId <- meterdata[meterdata$id == meterid,]  
    tsSingleMeterTS <- ts(singleMeterId$val,start=c(2016,as.POSIXlt("2016-08-26")$yday+1),frequency=365)
    # plot(tsSingleMeterTS)
    # dec <- decompose(tsSingleMeterTS)
    # plot(dec)
    # length(tsSingleMeter)
    sd(tsSingleMeterTS)
    if(length(tsSingleMeterTS)==95 && sd(tsSingleMeterTS) !=0){
      message("meterid",meterid)
      trainingTS <- window(tsSingleMeterTS,end=c(2016,290))
      testingTS <- window(tsSingleMeterTS,start = c(2016,290),end=c(2016,302))
      # etsdata <- ets(trainingTS)
      # faaTS <- forecast(etsdata,h=12)
      # plot(faaTS, main = "Prediction")
      # lines(testingTS, col = "red")
      aarima <- arima(trainingTS,order = c(1,1,8))
      faaTS <- forecast(aarima,h=12)
      plot(faaTS, main = "Prediction")
      lines(testingTS, col = "red")
      
    }
  }
  dev.off()
}
