import os
from source.CsvGenerator import generator_csv
from source.CustomLogger import CustomLogger
from source.DatesUtil import addMissingDates
from source.SingleMeterDataGenerator import forecast_factors
from source.TimeSeriesImpute import imputeTS

from source.Dataset import trainingDataSet
from source.SummaryOfMeters import pre_processing
from source.SummaryOfMeters import too_many_zero_values
from source.AccuracyMeasuresForecast import calculate_mape
from source.AccuracyMeasuresForecast import calculate_mape_weekly
import csv
import pandas as pd

logger = CustomLogger("Main").logger

def forecast_factors_range(singleMeterData,no_of_days):
    added_missing_dates = addMissingDates(singleMeterData, 'ts')
    added_missing_dates = added_missing_dates.replace([0.00], [None])
    single_meter_data_imputed = imputeTS(added_missing_dates, cyclePeriod)
    sorted_single_meterData = single_meter_data_imputed.sort_values(["ts", "id", "val", "val1"], ascending=[1, 0, 0, 0])

    for day in range(0,no_of_days):
        sorted_single_meterData=forecast_factors(sorted_single_meterData)
    return sorted_single_meterData
# 016499E8-C930-4A11-9DF1-52704BE9575C
def computeAllMeterData(no_of_meters):
    first_ten_meters=[]
    # for i in range(0,no_of_meters):
    for meter in meterids[0:no_of_meters]:
        first_ten_meters.append(meter)

    pre_processing_data=pre_processing(meterdata)
    too_many_missing_dates=pre_processing_data[pre_processing_data['percentage_missing_date'] > 10.00]
    too_many_missing_dates_list=[]
    too_many_zero_values_list=too_many_zero_values()
    for id in too_many_missing_dates['id']:
        too_many_missing_dates_list.append(id)
    calculate_mape_weekly_dict={}
    for meter in first_ten_meters:
        if (meter in too_many_missing_dates_list) or meter in too_many_zero_values_list:
            logger.info("Meter data is sparse - could not process: %s " %meter)
            logger.info('Missing dates %s' %len(too_many_missing_dates_list))
            logger.info(" or number of zero values %s" %len(too_many_zero_values_list) )
            continue
        else:
            singleMeterData = meterdata[meterdata['id'] == meter]
            meter_forecast = forecast_factors_range(singleMeterData, no_of_days)
            # print(meter_forecast.columns)
            logger.info(" Completed forecast for meter id: %s " %meter)
            #writing weekly_dect to dictionary
            calculate_mape_weekly_dict.update({meter:calculate_mape_weekly(meter_forecast.val1,meter_forecast.prediction,42)})
            try:
                output_filename = '../out'
                generator_csv(output_filename + "/" + meter + "_", meter_forecast)
            except Exception as filewriteException:
                logger.info(" Exception in generating file for forecast meter: %s"%meter)
                logger.info(filewriteException)

    df_accurasy_dict=pd.DataFrame(calculate_mape_weekly_dict)
    df_accurasy_dict=df_accurasy_dict.T
    df_accurasy_dict.to_csv("../accuracy/AccuracyMeasure.csv")

# generator_csv("AccuracyMeasure",calculate_mape_weekly_list)
# workingDir = os.getcwd()
# parDir =
# logger.log(msg=" working dir %s " %workingDir,level=20)


filename = '../input/dmd_data_daily_170112.txt'

logger.log(msg="filename : %s "%filename,level=20)
try:
    meterdata = trainingDataSet(filename)
    meterids = meterdata.id.unique()
    # defining a the cycle period
    cyclePeriod = 7
    # for short prediction use 1 for medium range forecast use 2 for long prediction use 3
    preidctionType = [1, 2, 3]
    # Date format
    date_format = "%Y-%m-%d"
    no_of_days = 10
    computeAllMeterData(20)
except FileNotFoundError as fileNotFoundError:
    logger.log(msg ="Data set file is missing. Please check the file path %s " %fileNotFoundError,level=20)
