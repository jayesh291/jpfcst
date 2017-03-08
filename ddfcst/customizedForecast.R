source("ddfcst/libs.R")
source("ddfcst/constants.R")
source("ddfcst/dataset.R")

meterdata <- trained_data_set(train_data_set_filename)
meterid = "0071CFB0-D92D-4035-ABA6-1AB961E4F573"

singleMeterData <- meterdata[meterdata$id == meterid,]
ma <- movingAverage(singleMeterData$val,n=6)
weights <- c(0.85,0.9,0.95,1.05,1.1,1.15)
wmv <- weightedMovingAverage(ma,weights)
binddata <- cbind(ma,wmv)
write.csv(wmv, file="./outs/wma.csv")


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
      wma[i] <- (movingAverage[i-1]*weights[1]+movingAverage[i-2]*weights[2]+movingAverage[i-3]*weights[3]
      +movingAverage[i-4]*weights[4]+movingAverage[i-5]*weights[5] + movingAverage[i-6]*weights[6])-movingAverage[i-6]+movingAverage[i-1]
    }
       i <- i + 1
  }
  return(wma)
  
}


movingAverage <- function(unitData, n, centered=FALSE) {
  if (centered) {
    before <- floor  ((n-1)/2)
    after  <- ceiling((n-1)/2)
  } else {
    before <- n-1
    after  <- 0
  }
  sumofData     <- rep(0, length(unitData))
  count <- rep(0, length(unitData))
  new <- unitData
  count <- count + !is.na(new)
  new[is.na(new)] <- 0
  sumofData <- sumofData + new
  i <- 1
  while (i <= before) {
    new   <- c(rep(NA, i), unitData[1:(length(unitData)-i)])
    count <- count + !is.na(new)
    new[is.na(new)] <- 0
    sumofData <- sumofData + new
    i <- i+1
  }
  i <- 1
  while (i <= after) {
    new   <- c(unitData[(i+1):length(unitData)], rep(NA, i))
    count <- count + !is.na(new)
    new[is.na(new)] <- 0
    sumofData <- sumofData + new
    i <- i+1
  }
  return(sumofData/count)
}
