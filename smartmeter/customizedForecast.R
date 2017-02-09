
source("libs.R")
source("constants.R")
source("movingAverage.R")
source("weightedMovingAverage.R")
source("dailyPattern.R")
source("ratioPrevMA.R")
#' Forecast time sereis
#'
#' A template to forecast daily, monthly and yearly  time sereis data
#' @param timesereis data as single column
#' @param frame is number of items to define a cycle of ts
#' @return Forecasted time sereis
#' @export
forecastikl <- function(timesereis, frame) {
  tsMeterData <- timesereis
  ma <- movingAverage(tsMeterData,n=frame)
  weights <- c(0.80,0.85,0.9,0.95,1.05,1.1,1.15)
  wmv <- weightedMovingAverage(ma,weights)
  dailyPatterns <- dailyPattern(tsMeterData,ma,length(weights))
  rdpwm <- ratioPrevMA(ma,dailyPatterns, frame)
  binddata <- cbind(tsMeterData,rdpwm)
  bf <- as.data.frame(binddata)
  bf$tsMeterData[(length(bf$tsMeterData)-frame):length(bf$tsMeterData)] <- NA
  return(bf)
}
  # ggplot(bf, aes(c(1:length(tsMeterData))))+geom_line(aes(y = rdpwm, colour = "Predicted"))+geom_line(aes(y = tsMeterData, colour = "Actual"))

#' Default dataset of package
#' no parameter
#' @return meter data from nov - dec
#' @export
SmartMeter <- function(){
  meterdata <-
    read.csv(
      "dmd_data_daily_170112.txt",
      sep = "\t",
      header = FALSE,
      col.names = c("id", "ts", "val")
    )
  sorteddata <- meterdata[order(meterdata$id, meterdata$ts),]
  sorteddata$ts1 <- as.POSIXct(x = sorteddata$ts, format = "%Y-%m-%d")
return(sorteddata)

}



