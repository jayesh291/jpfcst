

source("ddfcst/libs.R")
source("ddfcst/constants.R")
source("ddfcst/dataset.R")
source("ddfcst/datapreprocess.R")
source("ddfcst/engine.R")
source("ddfcst/timeseriesProcessing.R")
source("ddfcst/plots.R")
source("ddfcst/forecast.R")

meterdata <- trained_data_set(train_data_set_filename)
plot_daily_meter_consumption(meterdata,daily_dmd_plot_filename)
timeseriesData <- preprocess(meterdata)
distanceMatrix <- distanceMatrixCorr(timeseriesData)
numOfClust = 15
tsHclust <- tsHclust(distanceMatrix, numOfClust = numOfClust)
timeseriesHclustUsingCorrelation(timeseriesData)
head(timeseriesData)
representiveTimeSeries <- representativeTimeSeries(tsHclust,timeseriesData,meterdata)

forecastedMeters(meterdata)








