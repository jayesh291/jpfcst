ratioPrevMA <- function(ma,dailyPatterns,noOfDays){
  
  rdpwma <- c()
  i=1
  for(element in dailyPatterns){
    if( i > noOfDays){
      rdpwma[i] <-ma[i]/ma[i - noOfDays]  
    }else{
      rdpwma[i] <- 1
    }
    i <- i + 1
  }
  return(rdpwma)
}





