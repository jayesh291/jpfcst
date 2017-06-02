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


maxNormalization <- function(x,y){
  x <- ifelse(x<y,x,y*(x*cyclePeriod/10))
  return(x)
}

# originalTs <- meterdata[meterdata$id == meterid,]
# as.numeric(singleMeterData$val)-originalTs$val
# maxV <- maxVector(as.numeric(singleMeterData$val),originalTs$val ,7)
# maxV
