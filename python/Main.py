from CsvGenerator import generator_csv
from Dataset import trainingDataSet
from DatesUtil import addMissingDates
from SingleMeterDataGenerator import forecast_factors
from TimeSeriesImpute import imputeTS

# Read data set from a file
meterdata = trainingDataSet('dmd_data_daily_170112.txt')
meterids = meterdata.id.unique()

# defining a the cycle period
cyclePeriod = 7
# for short prediction use 1 for medium range forecast use 2 for long prediction use 3
preidctionType = [1, 2, 3]
# Date format
date_format = "%Y-%m-%d"
no_of_days=10

# for meter in meterids:
#     singleMeterData = meterdata[meterdata['id'] == meter]

def forecast_factors_range(singleMeterData,no_of_days):
    added_missing_dates = addMissingDates(singleMeterData, 'ts')
    single_meter_data_imputed = imputeTS(added_missing_dates, 7)
    sorted_single_meterData = single_meter_data_imputed.sort_values(["ts", "id", "val", "val1"], ascending=[1, 0, 0, 0])
    for day in range(0,no_of_days):
        sorted_single_meterData=forecast_factors(sorted_single_meterData)
    return sorted_single_meterData

def computeAllMeterData(no_of_meters):
    first_ten_meters=[]
    # for i in range(0,no_of_meters):
    for meter in meterids[0:no_of_meters]:
        first_ten_meters.append(meter)

    for meter in first_ten_meters:
        singleMeterData = meterdata[meterdata['id'] == meter]
        print meter
        meter_forecast = forecast_factors_range(singleMeterData, no_of_days)
        generator_csv("out" + "/" + meter + "_", meter_forecast)

computeAllMeterData(20)
