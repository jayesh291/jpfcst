source("constants.R")
source("dataset.R")
source("customizedForecast.R")

meterdata <- trained_data_set("dmd_data_daily_170112.txt")
meterids <- unique(meterdata$id)
meterid <- sample(meterids,1)
singleMeterData <- meterdata[meterdata$id == meterid,]
forecastikl(singleMeterData$val,7)
fc <- forecastikl(singleMeterData$val,7)
ggplot(as.data.frame(fc), aes(c(1:length(fc$tsMeterData))))+geom_line(aes(y = fc$rdpwm, colour = "Predicted"))+geom_line(aes(y = fc$tsMeterData, colour = "Actual"))
