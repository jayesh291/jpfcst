import numpy as np
from BaseValue import baseValueForTsForecast
from DailyPattern import dailyPattern
from Dataset import trainingDataSet
from MovingAverage import movingAverage
from Normalization import maxVector
from CustomLogger import  *

def minVector(timeseries, cyclePeriod):
    minVector =[]
    try:
        timeseries=timeseries.tolist()
        for i in range(0,len(timeseries)):
            if i > (cyclePeriod+1):
                try:
                    minVector.append(min(timeseries[0:i]))
                except ArithmeticError as arithMaticException:
                    logger.log(msg=" Exception timesereis min calculation  %s" %arithMaticException,level=level)
            else:
                minVector.append(timeseries[i])
    except Exception as exception:
        logger.log(msg=" Exception timeseries for loop exception %s" %exception,level=level)
    finally:
        logger.log(msg=" Timeseries min vector length %s " %len(minVector),level=level)
        return minVector


def minValueWeeklyTrend(timeseries):
    minWeeklyTrend=[]
    try:
        minWeeklyTrend.append(timeseries[0])
        minWeeklyTrend.append(timeseries[1])
        for i in range(2,len(timeseries)):
            minWeeklyTrend.append(timeseries[i-2]/timeseries[i-1])
    except Exception as exception:
        logger.log(msg=" Exception in weekly trend calculation: %s" %exception,level=level)
        logger.log(exception)
    finally:
     return minWeeklyTrend

def minValueAvg(timeseries):
    minValueWeeklyAvgTrend = []
    try:
        for i in range(0, len(timeseries)):
            if i > 21:
                minValueWeeklyAvgTrend.append(np.mean(timeseries[(i-21):(i-1)]))
            else:
                minValueWeeklyAvgTrend.append(timeseries[i])
    except Exception as expectation:
        logger.log(msg=" Exception in min Avg value - %s" %expectation,level=30)
        logger.log(expectation)
    finally:
        logger.log(msg=" Created vector of min value %s" %len(minValueWeeklyAvgTrend),level=level)
        return minValueWeeklyAvgTrend


logger = CustomLogger("ScaleFactor").logger
# info 20, Warning 30,
level = 20

def main():
    # Any code you like
    # run to test the function
    meterdata = trainingDataSet('input/dmd_data_daily_170112.txt')
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
    logger.log(msg = min_value_avg,level=20)
    print (min_value_avg)

if __name__ == '__main__':
  main()