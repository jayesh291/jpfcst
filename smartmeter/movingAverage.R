movingAverage <- function(unitData, n, centered=FALSE) {
  before <- n-1
  after  <- 0
  valCount <- length(unitData)+n
  sumofData     <- rep(0, valCount)
  count <- rep(0, valCount)
  new <- unitData
  count <- count + !is.na(new)
  new[is.na(new)] <- 0
  sumofData <- sumofData + new
  i <- 1
  while (i <= before) {
    new   <- c(rep(NA, i), unitData[1:(valCount-i)])
    count <- count + !is.na(new)
    new[is.na(new)] <- 0
    sumofData <- sumofData + new
    i <- i+1
  }
  i <- 1
  while (i <= after) {
    new   <- c(unitData[(i+1):valCount], rep(NA, i))
    count <- count + !is.na(new)
    new[is.na(new)] <- 0
    sumofData <- sumofData + new
    i <- i+1
  }
  return(sumofData/count)
}