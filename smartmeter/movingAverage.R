# Moving avg excluding the day, for current use prev n days avg 
# unitData <- tsMeterData
# n = 7
movingAverage <- function(unitData, n){
  ma <- c()
  for(j in 1:(length(unitData)+1)){
    if(j > n){
      ma[j] <- mean(unitData[(j-n):(j-1)])
    }else{
      ma[j] <- unitData[j]
    }
  }
  return(ma)
}




