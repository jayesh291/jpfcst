import numpy as np
import pandas as pd

from DatesUtil import addMissingDates
from TimeSeriesImpute import imputeTS
from BaseValue import baseValueForTsForecast
from DailyPattern import dailyPattern
from Dataset import trainingDataSet
from MovingAverage import movingAverage
from Normalization import maxVector
from ScaleFactor import minvalueavg
from ScaleFactor import minvalueweeklytrend
from ScaleFactor import minvector

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

    addedMissingDates = addMissingDates(singleMeterData, 'ts')
    singleMeterDataImputed = imputeTS(addedMissingDates, 7)
    sortedSingleMeterData = singleMeterDataImputed.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
    base_values = baseValueForTsForecast(sortedSingleMeterData.val, cyclePeriod, 3)
    moving_average = movingAverage(sortedSingleMeterData.val, cyclePeriod)
    daily_pattern = dailyPattern(sortedSingleMeterData.val, moving_average, cyclePeriod)
    max_vector = maxVector(sortedSingleMeterData.val, sortedSingleMeterData.val, cyclePeriod)
    normalization = np.array(daily_pattern)*0.2/np.array(max_vector)+0.9
    base_prediction = np.array(base_values) * np.array(normalization)
    min_vector = minvector(base_prediction, cyclePeriod)
    minValueWeeklyTrend = minvalueweeklytrend(min_vector)
    avgMinValues = minvalueavg(minValueWeeklyTrend)
    prediction = base_prediction * avgMinValues

    sLength = len(singleMeterData['id'])
    singleMeterData.loc[:, 'base_values'] = pd.Series(np.random.randn(sLength), index=singleMeterData.index)
    singleMeterData.loc[:, 'moving_average'] = pd.Series(np.random.randn(sLength), index=singleMeterData.index)
    singleMeterData.loc[:, 'daily_pattern'] = pd.Series(np.random.randn(sLength), index=singleMeterData.index)
    singleMeterData.loc[:, 'max_vector'] = pd.Series(np.random.randn(sLength), index=singleMeterData.index)
    singleMeterData.loc[:, 'normalization'] = pd.Series(np.random.randn(sLength), index=singleMeterData.index)
    singleMeterData.loc[:, 'base_prediction'] = pd.Series(np.random.randn(sLength), index=singleMeterData.index)
    singleMeterData.loc[:, 'min_vector'] = pd.Series(np.random.randn(sLength), index=singleMeterData.index)
    singleMeterData.loc[:, 'minValueWeeklyTrend'] = pd.Series(np.random.randn(sLength), index=singleMeterData.index)
    singleMeterData.loc[:, 'avgMinValues'] = pd.Series(np.random.randn(sLength), index=singleMeterData.index)
    singleMeterData.loc[:, 'prediction'] = pd.Series(np.random.randn(sLength), index=singleMeterData.index)


    print singleMeterData