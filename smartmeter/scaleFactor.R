minVector <- function(mdata,numOfDays){
  minVector <- {}
  for(i in 1:length(mdata)){
    if( i > (numOfDays+1)){
      minVector[i] <- min(mdata[(numOfDays+1):i])
    }else{
      minVector[i] <- mdata[i]
    }
  }
  return(minVector)
}

minValueWeeklyTrend <- function(minValueVectors){
  minValueWeeklyTrend <- {}
  minValueWeeklyTrend[1] <- minValueVectors[1]
  minValueWeeklyTrend[2] <- minValueVectors[2]
  for(i in 3:length(minValueVectors)){
    minValueWeeklyTrend[i] <- minValueVectors[i-2]/minValueVectors[i-1]
  }
  return(minValueWeeklyTrend)
}


minValueAvg <- function(minValueVector){
  minValueWeeklyTrend <- {}
  for(i in 1:length(minValueVector)){
    if( i > 21){
     minValueWeeklyTrend[i] <- mean(minValueVector[(i-21):(i-1)])
    }else{
      minValueWeeklyTrend[i] <- minValueVector[i]
    }
  }
  return(minValueWeeklyTrend)
}
