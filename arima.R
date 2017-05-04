install.packages("TTR")
install.packages("forecast")

library("TTR")
library("forecast")

plotForecastErrors <- function(forecasterrors)
{
  # make a histogram of the forecast errors:
  mybinsize <- IQR(forecasterrors)/4
  mysd   <- sd(forecasterrors)
  mymin  <- min(forecasterrors) - mysd*5
  mymax  <- max(forecasterrors) + mysd*3
  # generate normally distributed data with mean 0 and standard deviation mysd
  mynorm <- rnorm(10000, mean=0, sd=mysd)
  mymin2 <- min(mynorm)
  mymax2 <- max(mynorm)
  if (mymin2 < mymin) { mymin <- mymin2 }
  if (mymax2 > mymax) { mymax <- mymax2 }
  # make a red histogram of the forecast errors, with the normally distributed data overlaid:
  mybins <- seq(mymin, mymax, mybinsize)
  hist(forecasterrors, col="red", freq=FALSE, breaks=mybins)
  # freq=FALSE ensures the area under the histogram = 1
  # generate normally distributed data with mean 0 and standard deviation mysd
  myhist <- hist(mynorm, plot=FALSE, breaks=mybins)
  # plot the normal curve as a blue line on top of the histogram of forecast errors:
  points(myhist$mids, myhist$density, type="l", col="blue", lwd=2)
}

singleMeterSeries <- ts(singleMeterData$val, frequency = 7)
plot.ts(singleMeterSeries)

# singleMeterDataSMA <- SMA(singleMeterSeries, n=5)
# plot.ts(singleMeterDataSMA)

singleMeterTsComponents <- decompose(singleMeterSeries)
plot(singleMeterTsComponents)

singleMeterTsSeasonallyAdjusted <- singleMeterSeries - singleMeterTsComponents$seasonal
plot(singleMeterTsSeasonallyAdjusted)

singleMeterForecasts <- HoltWinters(singleMeterSeries)
singleMeterForecasts
plot(singleMeterForecasts)
singleMeterForecasts$SSE

singleMeterForecasts2 <- forecast.HoltWinters(singleMeterForecasts, h=180)
singleMeterForecasts2
plot.forecast(singleMeterForecasts2)

acf(singleMeterForecasts2$residuals, lag.max=20, na.action = na.pass)
Box.test(singleMeterForecasts2$residuals, lag=20, type="Ljung-Box")

plot.ts(singleMeterForecasts2$residuals)            # make a time plot
plotForecastErrors(singleMeterForecasts2$residuals[!is.na(singleMeterForecasts2$residuals)]) # make a histogram

