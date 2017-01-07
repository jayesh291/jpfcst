

source("lib_import.R")
source("constants.R")
source("dataset.R")
source("daywise charts.R")
source("preprocess.R")

# setwd("Desktop/ikl/delmon/git/jpfcst/")
# meterdata <- trained_data_set("temp_dmd_data_daily.txt")
# timeseries_meter_data <- preprocess(meterdata)


plot_daily_meter_consumption(meterdata,daily_dmd_plot_filename)



