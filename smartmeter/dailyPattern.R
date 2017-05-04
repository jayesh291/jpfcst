dailyPattern <- function(tsMeterData,movingAverage,noOfDays){
  dpwma <- c()
  i=1
  for(i in 1:(length(tsMeterData)+1)){
    if( i > noOfDays){
      dpwma[i] <- tsMeterData[i-noOfDays]/movingAverage[i - noOfDays]  
    }else{
      dpwma[i] <- movingAverage[i]
    }
    i <- i + 1
  }
  return(dpwma)
}
