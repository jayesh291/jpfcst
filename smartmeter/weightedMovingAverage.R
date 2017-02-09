weightedMovingAverage <- function(movingAverage,weights){
  numOfWeightedElements <- length(weights)  
  wma <- c()
  i=1
  weightCount=1
  for(element in movingAverage){
    if( i <= numOfWeightedElements){
      wma[i] <- element*weights[i]
    } else{
      
      if(weightCount == numOfWeightedElements){
        weightCount <- 1
      }else{
        weightCount <- weightCount + 1
      }
      wma[i] <- ((movingAverage[i-1]*weights[1]+movingAverage[i-2]*weights[2]+movingAverage[i-3]*weights[3]
                  +movingAverage[i-4]*weights[4]+movingAverage[i-5]*weights[5] + movingAverage[i-6]*weights[6])-movingAverage[i-6]+movingAverage[i-1])/6
    }
    i <- i + 1
  }
  return(wma)
  
}
