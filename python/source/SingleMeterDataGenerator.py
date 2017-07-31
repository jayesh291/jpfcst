from datetime import  datetime
from datetime import  timedelta

import numpy as np
import pandas as pd
from source.BaseValue import baseValueForTsForecast
from source.CustomLogger import CustomLogger
from source.DailyPattern import dailyPattern
from source.Normalization import maxVector
from pandas.core.base import DataError

from source.MovingAverage import movingAverage
from source.ScaleFactor import minValueAvg
from source.ScaleFactor import minValueWeeklyTrend
from source.ScaleFactor import minVector


def forecast_factors(sorted_single_meterData):
    try:
       base_values = baseValueForTsForecast(sorted_single_meterData.val1, cyclePeriod, 3)
    except Exception as exception:
        logger.log(msg=" Exception in base value %s" % exception, level=level)
    try:
        moving_average = movingAverage(sorted_single_meterData.val1, cyclePeriod) # Customized function for dynamic cyclic period
    except Exception as exception:
        logger.log(msg=" Exception in MovingAverage %s" % exception, level=level)
    try:
        daily_pattern = dailyPattern(sorted_single_meterData.val1, moving_average, cyclePeriod)
    except Exception as exception:
        logger.log(msg=" Exception in DailyPattern %s" % exception, level=level)
    try:
        max_vector = maxVector(sorted_single_meterData.val1, sorted_single_meterData.val1, cyclePeriod)
    except Exception as exception:
        logger.log(msg=" Exception in Max Vector %s" % exception, level=level)
    try:
        normalization = np.array(daily_pattern)*0.2/np.array(max_vector)+0.9
    except Exception as exception:
        logger.log(msg=" Exception in Normalization %s" % exception, level=level)
    try:
        base_prediction = np.array(base_values) * np.array(normalization)
    except Exception as exception:
        logger.log(msg=" Exception in BasePrediction %s" % exception, level=level)
    try:
        min_vector = minVector(base_prediction, cyclePeriod)
    except Exception as exception:
        logger.log(msg=" Exception in MinVector %s" % exception, level=level)
    try:
        min_value_weekly_trend = minValueWeeklyTrend(min_vector)
    except Exception as exception:
        logger.log(msg=" Exception in MinValueWeeklyTrend %s" % exception, level=level)
    try:
        avg_min_values = minValueAvg(min_value_weekly_trend)
    except Exception as exception:
        logger.log(msg=" Exception in AvgMinValues %s" % exception, level=level)
    try:
        prediction = base_prediction * avg_min_values
    except Exception as exception:
        logger.log(msg="Lenght of base_prediction : %s and avg_min_values : %s are mismatch %s"%len(base_prediction) %len(avg_min_values) %exception, level=level)

    try:
        sorted_single_meterData['base_values'] = pd.Series(base_values)
        sorted_single_meterData['moving_average'] = pd.Series(moving_average)
        sorted_single_meterData['daily_pattern'] = pd.Series(daily_pattern)
        sorted_single_meterData['max_vector'] = pd.Series(max_vector)
        sorted_single_meterData['normalization'] = pd.Series(normalization)
        sorted_single_meterData['base_prediction'] = pd.Series(base_prediction)
        sorted_single_meterData['min_vector'] = pd.Series(min_vector)
        sorted_single_meterData['minValueWeeklyTrend'] = pd.Series(min_value_weekly_trend)
        sorted_single_meterData['avgMinValues'] = pd.Series(avg_min_values)
        sorted_single_meterData['prediction'] = pd.Series(prediction)
        df = pd.DataFrame(data=None)
        df["base_value"]=pd.Series(base_values)
        df['base_values'] = pd.Series(base_values)
        df['moving_average'] = pd.Series(moving_average)
        df['daily_pattern'] = pd.Series(daily_pattern)
        df['max_vector'] = pd.Series(max_vector)
        df['normalization'] = pd.Series(normalization)
        df['base_prediction'] = pd.Series(base_prediction)
        df['min_vector'] = pd.Series(min_vector)
        df['minValueWeeklyTrend'] = pd.Series(min_value_weekly_trend)
        df['avgMinValues'] = pd.Series(avg_min_values)
        df['prediction'] = pd.Series(prediction)
    except DataError as dataEror:
        logger.log(msg=" Exception in dataframe %s" % dataEror, level=level)

    last_date = datetime.strptime(sorted_single_meterData.loc[len(sorted_single_meterData) - 1, 'ts'], date_format)
    next_date = datetime.strftime(last_date + timedelta(1), date_format)
    last_row = [sorted_single_meterData.loc[0, 'id'], next_date,base_prediction[len(base_prediction)-1]]
    for data in df.ix[len(df)-1]:
        last_row.append(data)
    sorted_single_meterData.loc[len(sorted_single_meterData)] = last_row

    # generator_csv("sorted_single_meterData",sorted_single_meterData)
    return sorted_single_meterData


# defining a the cycle period
cyclePeriod = 7
# for short prediction use 1 for medium range forecast use 2 for long prediction use 3
preidctionType = [1, 2, 3]
# Date format
date_format="%Y-%m-%d"
#Logging object are created
logger=CustomLogger("SingleMeterDataGenerator").logger
level=20

