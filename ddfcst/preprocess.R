data_to_ts <- function(data_set_ts){
  timeseries_data <- cast(data_set_ts, id~ts1, value = "val")
  return(timeseries_data)
}

preprocess <- function(rawdata){
  timeseries_data <- data_to_ts(rawdata)
  head(rawdata)
  return(timeseries_data)
}


