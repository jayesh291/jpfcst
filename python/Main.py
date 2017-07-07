import pandas as pd
import numpy as np

from Dataset import trainingDataSet
from BaseValue import baseValueForTsForecast
from MovingAverage import movingAverage
from DailyPattern import dailyPattern
from Normalization import maxVector

# Read data set from a file
meterdata = trainingDataSet('dmd_data_daily_170112.txt')
meterids = meterdata.id.unique()

# defining a the cycle period
cyclePeriod = 7
# for short prediction use 1 for medium range forecast use 2 for long prediction use 3
preidctionType = [1, 2, 3]

for meter in meterids:
    singleMeterData = meterdata[meterdata['id'] == meter]


def forecast_factors(singleMeterData):
    sortedSingleMeterData = singleMeterData.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
    base_values = baseValueForTsForecast(sortedSingleMeterData.val, cyclePeriod, 3)
    moving_average = movingAverage(sortedSingleMeterData.val, cyclePeriod)
    daily_pattern = dailyPattern(sortedSingleMeterData.val, moving_average, cyclePeriod)
    max_vector = maxVector(sortedSingleMeterData.val, sortedSingleMeterData.val, cyclePeriod)
