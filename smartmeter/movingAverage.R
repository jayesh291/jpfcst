# Moving avg excluding the day, for current use prev n days avg 
movingAverage <- function(unitData, n){
  ma <- c()
  for(j in 1:(length(unitData)+1)){
    if(j <= n){
      ma[j] <- unitData[j]
    }else{
      ma[j] <- mean(tsMeterData[(j-n):(j-1)])
      
    }
  }
  return(ma)
}





# Normal moving avg
# movingAverageB <- function(unitData, n, centered=FALSE) {
#   before <- n-1
#   after  <- 0
#   valCount <- length(unitData)
#   sumofData     <- rep(0, valCount)
#   count <- rep(0, valCount)
#   new <- unitData
#   count <- count + !is.na(new)
#   new[is.na(new)] <- 0
#   sumofData <- sumofData + new
#   i <- 1
#   while (i <= before) {
#     new   <- c(rep(NA, i), unitData[1:(valCount-i)])
#     count <- count + !is.na(new)
#     new[is.na(new)] <- 0
#     sumofData <- sumofData + new
#     i <- i+1
#   }
#   i <- 1
#   while (i <= after) {
#     new   <- c(unitData[(i+1):valCount], rep(NA, i))
#     count <- count + !is.na(new)
#     new[is.na(new)] <- 0
#     sumofData <- sumofData + new
#     i <- i+1
#   }
#   return(sumofData/count)
# }


