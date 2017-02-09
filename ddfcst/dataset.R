trained_data_set <- function(traindata_filename){
  meterdata <-
    read.csv(
      traindata_filename,
      sep = "\t",
      header = FALSE,
      col.names = c("id", "ts", "val")
    )
  sorteddata <- meterdata[order(meterdata$id, meterdata$ts),]
  sorteddata$ts1 <- as.POSIXct(x = sorteddata$ts, format = "%Y-%m-%d")

  return(sorteddata)
}

testing_data_set <- function(testdata_filename){
  
  return(test_data);
}