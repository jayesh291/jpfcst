from Dataset import trainingDataSet


# Base value for forececast given timeseries data, num of days are cycle period,
# forecast period is short,medium, long
def baseValueForTsForecast(tsMeterData, numOfDays, forecastPeriod):
    numOfDaysToPredict = numOfDays * forecastPeriod
    basevalue = []
    for i in range(1, len(tsMeterData) + 1):
        if i > numOfDaysToPredict:
            basevalue.append(tsMeterData[i - numOfDaysToPredict])
        else:
            basevalue.append(tsMeterData[i])
    return basevalue


# Run to test the above function
meterdata = trainingDataSet('dmd_data_daily_170112.txt')
meterids = meterdata.id.unique()
singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
sortedSingleMeterData = singleMeterData.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
timeseries = singleMeterData.val
basevalues = baseValueForTsForecast(timeseries, 7, 3)
