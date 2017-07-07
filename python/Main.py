import pandas as pd
import numpy as np

from Dataset import trainingDataSet
from BaseValue import baseValueForTsForecast

# Read data set from a file
meterdata = trainingDataSet('dmd_data_daily_170112.txt')
meterids = meterdata.id.unique()

for meter in meterids:
    singleMeterData = meterdata[meterdata['id'] == meter]
    # singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]


# for short prediction use 1 for medium range forecast use 2 for long prediction use 3
preidctionType = [1, 2, 3]


def forecast_factors(singleMeterData):
    sortedSingleMeterData = singleMeterData.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
    base_values = baseValueForTsForecast(sortedSingleMeterData.val, 7, 3)
