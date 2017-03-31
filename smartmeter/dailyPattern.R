dailyPattern <- function(tsMeterData,movingAverage,noOfDays){
  dpwma <- c()
  i=1
  for(element in movingAverage){
    if( i > noOfDays){
      dpwma[i] <- tsMeterData[i-noOfDays]*movingAverage[i]/movingAverage[i - noOfDays]  
    }else{
      dpwma[i] <- movingAverage[i]
    }
    i <- i + 1
  }
  return(dpwma)
}
