maxVector <- function(mdata,originalTs,cyclePeriod){
  # mdata<- singleMeterData$val
  # originalTs <- singleMeterData$val
  # cyclePeriod <- 7
  maxVector <- {}
  for(i in 2:(length(mdata)+1)){
    if(i > cyclePeriod){
      if(i <= length(originalTs)){
        maxVector[i] <- max(originalTs[2:(i-1)])
      }else{
        maxVector[i] <- max(originalTs[2:length(originalTs)])
      }
    }else{
      maxVector[i] <- max(originalTs[2:(i-1)])
    }
  }
  return(maxVector)
}

# maxV <- maxVector(singleMeterData$val,singleMeterData$val,7)
# maxV
