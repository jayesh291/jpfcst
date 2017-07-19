import numpy as np
import pandas as pd
from Dataset import trainingDataSet
from BaseValue import baseValueForTsForecast
from CsvGenerator import generator_csv
from DailyPattern import dailyPattern
from DatesUtil import addMissingDates
from Normalization import maxVector
from ScaleFactor import minValueAvg
from ScaleFactor import minValueWeeklyTrend
from ScaleFactor import minVector
from TimeSeriesImpute import imputeTS
from datetime import  datetime
from datetime import  timedelta
from MovingAverage import movingAverage

# Read data set from a file
meterdata = trainingDataSet('dmd_data_daily_170112.txt')
meterids = meterdata.id.unique()

# defining a the cycle period
cyclePeriod = 7
# for short prediction use 1 for medium range forecast use 2 for long prediction use 3
preidctionType = [1, 2, 3]
# Date format
date_format="%Y-%m-%d"

for meter in meterids:
    singleMeterData = meterdata[meterdata['id'] == meter]
        # forecast_factors(singleMeterData)

def forecast_factors(sorted_single_meterData):
    # added_missing_dates = addMissingDates(singleMeterData, 'ts')
    # single_meter_data_imputed = imputeTS(added_missing_dates, 7)
    # sorted_single_meterData = single_meter_data_imputed.sort_values(["ts", "id", "val","val1"], ascending=[1, 0, 0, 0])
    base_values = baseValueForTsForecast(sorted_single_meterData.val1, cyclePeriod, 3)
    moving_average = movingAverage(sorted_single_meterData.val1, cyclePeriod) # Customized function for dynamic cyclic period
    # moving_average = pd.rolling_mean(sorted_single_meterData.val1,7) # depricated
    # moving_average_series=pd.Series(sorted_single_meterData.val1)
    # moving_average= moving_average_series.rolling(window=cyclePeriod,center=False).mean()
    # moving_average[:cyclePeriod] = sorted_single_meterData.val[:cyclePeriod]
    daily_pattern = dailyPattern(sorted_single_meterData.val1, moving_average, cyclePeriod)
    max_vector = maxVector(sorted_single_meterData.val1, sorted_single_meterData.val1, cyclePeriod)
    normalization = np.array(daily_pattern)*0.2/np.array(max_vector)+0.9
    base_prediction = np.array(base_values) * np.array(normalization)
    min_vector = minVector(base_prediction, cyclePeriod)
    min_value_weekly_trend = minValueWeeklyTrend(min_vector)
    avg_min_values = minValueAvg(min_value_weekly_trend)
    prediction = base_prediction * avg_min_values
    # generator_csv("addMissingDates", added_missing_dates )
    # generator_csv("singleMeterDataImputed", single_meter_data_imputed)
    # generator_csv("sorted_single_meterData", single_meter_data_imputed)
    # generator_csv("baseValueForTsForecast", base_values)
    # generator_csv("movingAverage", moving_average)
    # generator_csv("dailyPattern", daily_pattern)
    # generator_csv("maxVector", max_vector)
    # generator_csv("normalization", normalization)
    # generator_csv("basePprediction", base_prediction)
    # generator_csv("minVector", min_vector)
    # generator_csv("minValueWeeklyTrend", minValueWeeklyTrend)
    # generator_csv("avgMinValues", avg_min_values)
    # generator_csv("prediction", prediction)
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
    last_date = datetime.strptime(sorted_single_meterData.loc[len(sorted_single_meterData) - 1, 'ts'], date_format)
    next_date = datetime.strftime(last_date + timedelta(1), date_format)
    last_row = [sorted_single_meterData.loc[0, 'id'], next_date,base_prediction[len(base_prediction)-1]]
    for data in df.ix[len(df)-1]:
        last_row.append(data)
    sorted_single_meterData.loc[len(sorted_single_meterData)] = last_row

    # generator_csv("sorted_single_meterData",sorted_single_meterData)
    return sorted_single_meterData

# forecast_factors(singleMeterData)
#
# def forecast_factors_range(singleMeterData,no_of_days):
#     added_missing_dates = addMissingDates(singleMeterData, 'ts')
#     single_meter_data_imputed = imputeTS(added_missing_dates, 7)
#     sorted_single_meterData = single_meter_data_imputed.sort_values(["ts", "id", "val", "val1"], ascending=[1, 0, 0, 0])
#     for day in range(0,no_of_days):
#         sorted_single_meterData=forecast_factors(sorted_single_meterData)
#
#     now = datetime.now()
#     meter="meter"
#     val = "%s%s%s%s%s%s" % (now.year, now.month, now.day, now.hour, now.month, now.second)
#     generator_csv("out" + "/" + meter + "_" + val ,sorted_single_meterData )
#
# forecast_factors_range(singleMeterData,100)