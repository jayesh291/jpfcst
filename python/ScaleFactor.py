import numpy as np
from BaseValue import baseValueForTsForecast
from DailyPattern import dailyPattern
from Dataset import trainingDataSet
from MovingAverage import movingAverage
from Normalization import maxVector

def minVector(timeseries, cyclePeriod):
    timeseries=timeseries.tolist()
    minVector =[]
    for i in range(0,len(timeseries)):
        if i > (cyclePeriod+1):
            minVector.append(min(timeseries[0:i]))
        else:
            minVector.append(timeseries[i])
    return minVector

def minValueWeeklyTrend(timeseries):
    minWeeklyTrend=[]
    minWeeklyTrend.append(timeseries[0])
    minWeeklyTrend.append(timeseries[1])
    for i in range(2,len(timeseries)):
        minWeeklyTrend.append(timeseries[i-2]/timeseries[i-1])
    return minWeeklyTrend

def minValueAvg(timeseries):
    minValueWeeklyAvgTrend = []
    for i in range(0, len(timeseries)):
        if i > 21:
            minValueWeeklyAvgTrend.append(np.mean(timeseries[(i-21):(i-1)]))
        else:
            minValueWeeklyAvgTrend.append(timeseries[i])
    return minValueWeeklyAvgTrend

# run to test the function
meterdata = trainingDataSet('dmd_data_daily_170112.txt')
meterids = meterdata.id.unique()
singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
# defining a the cycle period
cyclePeriod = 7
# for short prediction use 1 for medium range forecast use 2 for long prediction use 3
preidctionType = [1, 2, 3]
cycleperiod=7
sortedSingleMeterData = singleMeterData.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
base_values = baseValueForTsForecast(sortedSingleMeterData.val, cyclePeriod, 3)
moving_average = movingAverage(sortedSingleMeterData.val, cyclePeriod)
daily_pattern = dailyPattern(sortedSingleMeterData.val, moving_average, cyclePeriod)
max_vector = maxVector(sortedSingleMeterData.val, sortedSingleMeterData.val, cyclePeriod)
normalization = np.array(daily_pattern) * 0.2 / np.array(max_vector) + 0.9
base_prediction = np.array(base_values) * np.array(normalization)
min_vector = minVector(base_prediction,cycleperiod)
min_value_weekly_trend = minValueWeeklyTrend(min_vector)
min_value_avg = minValueAvg(min_value_weekly_trend)
# print min_value_avg