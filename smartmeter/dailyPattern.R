dailyPattern <- function(orgData,weightedMovingAverage,noOfDays){
  dpwma <- c()
  i=1
  weightCount=1
  for(element in weightedMovingAverage){
    if( i > noOfDays){
      dpwma[i] <- element* orgData[i - noOfDays]/weightedMovingAverage[i - noOfDays]  
    }else{
      dpwma[i] <- element
    }
    i <- i + 1
  }
  return(dpwma)
}