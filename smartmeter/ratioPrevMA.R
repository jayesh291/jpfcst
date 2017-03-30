ratioPrevMA <- function(ma,dailyPatterns,noOfDays){
  
  rdpwma <- c()
  i=1
  for(element in dailyPatterns){
    if( i > 2){
      rdpwma[i] <-dailyPatterns[i - 1]/dailyPatterns[i - 2]  
    }else{
      rdpwma[i] <- 1
    }
    i <- i + 1
  }
  return(rdpwma)
}





