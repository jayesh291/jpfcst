dailyPattern <- function(movingAverage,noOfDays){
  dpwma <- c()
  i=1
  weightCount=1
  prevWeek <- 2*noOfDays
  for(element in movingAverage){
    if( i > prevWeek){
      dpwma[i] <- movingAverage[i-noOfDays]/movingAverage[i - prevWeek]  
    }else{
      dpwma[i] <- movingAverage[i]
    }
    i <- i + 1
  }
  return(dpwma)
}