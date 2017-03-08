ratioPrevMA <- function(ma,dailyPattern,noOfDays){
  
  rdpwma <- c()
  i=1
  for(element in dailyPattern){
    if( i > 2){
      rdpwma[i] <- element* ma[i - 1]/ma[i - 2]  
      message("element : ",element," ma i-1 ", ma[i - 1]," ma i-2 ",ma[i - 2])
    }else{
      rdpwma[i] <- element
    }
    i <- i + 1
  }
  return(rdpwma)
}





