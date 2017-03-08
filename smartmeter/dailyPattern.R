dailyPattern <- function(orgData,movingAverage,noOfDays){
  dpwma <- c()
  i=1
  weightCount=1
  for(element in movingAverage){
    if( i > noOfDays){
      dpwma[i] <- element* orgData[i - noOfDays]/movingAverage[i - noOfDays]  
    }else{
      dpwma[i] <- element
    }
    i <- i + 1
  }
  return(dpwma)
}