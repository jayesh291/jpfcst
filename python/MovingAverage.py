import numpy as np
from Dataset import trainingDataSet
# Moving avg excluding the day, for current use prev n days avg
def movingAverage(timeseries,n):
    ma = []
    for j in range(0, len(timeseries)+1):
        if j >= (n + 1):
            ma.append(np.mean(timeseries[(j - n -1):(j-1)]))
        else:
            ma.append(timeseries[j])
    return ma

# # run to test the function
# meterdata = trainingDataSet('dmd_data_daily_170112.txt')
# singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
# sortedSingleMeterData = singleMeterData.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
# timeseries = sortedSingleMeterData.val
# sortedSingleMeterData.index = range(1, len(sortedSingleMeterData) + 1)
# data = sortedSingleMeterData.to_csv()
# ma = movingAverage(sortedSingleMeterData.val, 7)
# print ma