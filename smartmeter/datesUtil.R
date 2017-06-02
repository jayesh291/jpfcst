
missingDates <- function(data,dateCol) {
  # data <- originalData
  # dateCol <- "ts1"
  totalDiffDays <- abs(data[dateCol][1,] - data[nrow(data),c(dateCol)])
  missingDays <- totalDiffDays - nrow(data)+1
  message("Missing days in timeseries are : ",missingDays)
  alldays <- seq(data[1,dateCol],length=(totalDiffDays+1),by="+1 day")
  missingDates = alldays[!(alldays %in% data[,dateCol])]
  return(missingDates)
}

# missingDates(singleMeterData,"ts1")

addMissingDates <- function(data,dateCol) {
  
  missingDates <- missingDates(data,dateCol)
  nrow(data)
  # Append this `data.frame` and resort:
  i <- 1
  while(i <= length(missingDates)){
    # message(" i loopings -> ",i, " -- ",as.POSIXct(missingDates[i]))
    tempDate <- format(as.POSIXct(missingDates[i], origin="1970-01-01"),"%Y-%m-%d")
    data = rbind(data, c(as.character(meterid),as.character(tempDate),NA,tempDate),stringsAsFactors = FALSE)
    i <- i+1
  }
  data = data[order(data[,c(dateCol)]),]
  return(data)
}

# retrivedSMD <- addMissingDates(data = singleMeterData, "ts1")
# nrow(retrivedSMD)