rm(list = ls())

source("customizedForecast.R")

meterdata <- trained_data_set("dmd_data_daily_170112.txt")
meterids <- unique(meterdata$id)
meterid <- sample(meterids,1)

pdf(corrplot_filename)
for (meterid in meterids){
  singleMeterData <- meterdata[meterdata$id == meterid,]
  fc <- forecastikl(singleMeterData$val,7)
  
  
  ggp <- ggplot(as.data.frame(fc), aes(c(1:length(fc$tsMeterData)))) 
  ggp <- ggp + geom_line(aes(y = fc$rdpwm[fc$tsMeterData == "NA"], colour = "Predicted")) 
  ggp <- ggp + geom_line(aes(y = fc$tsMeterData, colour = "Actual")) 
  ggp <- ggp + ggtitle(paste0("Forecast for ", meterid )) 
  ggp <- ggp + xlab("Index") + ylab("Value")
  print(ggp)
}
dev.off()
