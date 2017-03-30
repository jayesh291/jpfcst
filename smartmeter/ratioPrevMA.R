ratioPrevMA <- function(ma,dailyPattern,noOfDays){
  
  rdpwma <- c()
  i=1
  for(element in dailyPattern){
    if( i > 2){
      rdpwma[i] <-ma[i - 1]/ma[i - 2]  
    }else{
      rdpwma[i] <- 1
    }
    i <- i + 1
  }
  return(rdpwma)
}





