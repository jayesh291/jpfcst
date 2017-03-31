basevalue <- function(timeseriesdata,noOfDaystoPredict){
  basevalue<-c()
  for(i in 1:(length(timeseriesdata)+1)){
    if(i > noOfDaystoPredict){
      basevalue[i] <- timeseriesdata[i - noOfDaystoPredict]
    }else{
      basevalue[i] <- timeseriesdata[i]
    }
  }
  return(basevalue)
}


# basevalueAvg <- function(timeseriesdata,noOfDaystoPredict){
#   bValues<-c()
#   for(i in 1:length(timeseriesdata)){
#     if(i > (2*noOfDaystoPredict)){
#       bValues[i] <- mean(timeseriesdata[i - noOfDaystoPredict],timeseriesdata[i - (noOfDaystoPredict*2)])
#                            # ,timeseriesdata[i - noOfDaystoPredict*3],timeseriesdata[i - noOfDaystoPredict*4])
#     }
#     trd <- 3*noOfDaystoPredict
#     if(i > trd){
#       bValues[i] <- mean(timeseriesdata[i - noOfDaystoPredict],timeseriesdata[i - (noOfDaystoPredict*2)]
#                            ,timeseriesdata[i - (noOfDaystoPredict*3)]);
#       # ,timeseriesdata[i - noOfDaystoPredict*4])
#       
#     }else{
#       bValues[i] <- timeseriesdata[i]
#     }
#   }
#   return(bValues)
# }
