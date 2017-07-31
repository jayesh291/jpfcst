from source.CustomLogger import CustomLogger

from source.Dataset import trainingDataSet

# from Main import filename
# Base value for forececast given timeseries data, num of days are cycle period,
# forecast period is short,medium, long

logger = CustomLogger("BaseValue").logger
level=20

def baseValueForTsForecast(tsMeterData, numOfDays, forecastPeriod):
    try:
        numOfDaysToPredict = numOfDays * forecastPeriod
        tsMeterData=tsMeterData.tolist()
        basevalue = []
        for i in range(0, len(tsMeterData) + 1):
            if i > numOfDaysToPredict:
                basevalue.append(tsMeterData[i - numOfDaysToPredict])
            else:
                basevalue.append(tsMeterData[i])
    except Exception as exception:
        logger.log(msg=" Exception for loop exception %s" % exception, level=level)
    finally:
        logger.log(msg=" BaseValue length is %s " % len(tsMeterData), level=level)
        return basevalue


# Run to test the above function
# meterdata = trainingDataSet('input/dmd_data_daily_170112.txt')
# meterids = meterdata.id.unique()
# singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
# sortedSingleMeterData = singleMeterData.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
# timeseries = singleMeterData.val
# basevalues = baseValueForTsForecast(timeseries, 7, 3)
