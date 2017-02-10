
source("customizedForecast.R")

meterdata <- trained_data_set("dmd_data_daily_170112.txt")
meterids <- unique(meterdata$id)
meterid <- sample(meterids,1)
pdf(file="./outs/fctplot_10_FEB_v.pdf")

for(meterid in meterids){
 singleMeterData <- meterdata[meterdata$id == meterid,]
 singleMeterData[is.na(singleMeterData)] <- 0
 forecastikl(singleMeterData$val,7)
 fc <- forecastikl(singleMeterData$val,7)
 plot(0,0,xlim = c(1,length(fc$tsMeterData)),ylim = c(min(singleMeterData$val),max(singleMeterData$val)),type = "n",xlab = meterid)
 lines(fc$tsMeterData,type = 'l')
 lines(fc$rdpwm,type = 'l', col = "red")
 dec <- decompose(ts(fc$tsMeterData, frequency = 7))
 plot(dec)
}
dev.off()