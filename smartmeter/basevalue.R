basevalue <- function(ma,noOfDaystoPredict){
  basevalue<-c()
  for(i in 1:length(ma)){
    if(i > noOfDaystoPredict){
      basevalue[i] <- ma[i - noOfDaystoPredict]
    }else{
      basevalue[i] <- ma[i]
    }
  }
  return(basevalue)
}
