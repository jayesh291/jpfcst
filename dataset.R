meterdata <-
  read.csv(
    "temp_dmd_data_daily.txt",
    sep = "\t",
    header = FALSE,
    col.names = c("id", "ts", "val")
  )
