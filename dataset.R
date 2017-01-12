meterdata <-
  read.csv(
    "dmd_data_daily_170112.txt",
    sep = "\t",
    header = FALSE,
    col.names = c("id", "ts", "val")
  )

