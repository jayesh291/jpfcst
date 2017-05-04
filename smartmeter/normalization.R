maxVector <- function(mdata){
  maxVector <- {}
  for(i in 2:(length(mdata)+1)){
    if(i > cyclePeriod){
      maxVector[i] <- max(mdata[2:(i-1)])
    }
  }
  return(maxVector)
}

