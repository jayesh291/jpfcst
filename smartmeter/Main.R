
getwd()
source("customizedForecast.R")

meterdata <- trained_data_set("dmd_data_daily_170112.txt")
meterids <- unique(meterdata$id)
meterid <- sample(meterids,1)
pdf(file="./outs/fctplot_5_Mar.pdf")
for(meterid in meterids){
  singleMeterData <- meterdata[meterdata$id == meterid,]
  singleMeterData[is.na(singleMeterData)] <- 0
  forecastikl(singleMeterData$val,7)
  fc <- forecastikl(singleMeterData$val,7)
  plot(0,0,xlim = c(1,length(fc$tsMeterData)),ylim = c(min(singleMeterData$val),max(singleMeterData$val)),type = "n",xlab = meterid)
  lines(fc$tsMeterData,type = 'l')
  lines(fc$rdpwm,type = 'l', col = "red")
  mapeerror <- abs((fc$tsMeterData[1:50]-fc$rdpwm[1:50])/fc$tsMeterData[1:50]) * 100
  mapeerror[is.na(mapeerror)] <- 0.00001
  mapeerror[is.infinite(mapeerror)] <- 0.00001
  fcresults <- cbind(fc$tsMeterData,fc$rdpwm,mapeerror)
  df.fc <- as.data.frame(fcresults)
  ab =mean(mapeerror[length(fc$rdpwm)-15:(length(fc$rdpwm)-8)])
  fileName <- paste0("./outs/",meterid,"mape",ab,".csv")
  write.csv(df.fc,file=fileName)
  plot(dec)
}
dev.off()

