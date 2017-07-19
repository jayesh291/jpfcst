import numpy as np
from Dataset import trainingDataSet
from DatesUtil import addMissingDates
import pandas as pd
#  Customized implementaion
def imputeTS(timeseries1, days):
    timeseries=[]
    for data in timeseries1['val']:
        timeseries.append(data)
    days = 7
    i = 0
    while i < len(timeseries):
        if np.isnan(timeseries[i]):
            if i <= days:
                for j in range(1,12):
                    if not np.isnan(timeseries[i + (days * j)]):
                        timeseries[i] =  timeseries[i + (days * j)]
                        break
            else:
                timeseries[i] = timeseries[i - days]
        i+=1

    timeseries=pd.DataFrame(timeseries)
    timeseries1 = pd.DataFrame(timeseries1).reset_index(timeseries,drop=True)
    timeseries1['val1'] = timeseries[0]
    return timeseries1

# run to test the function
meterdata = trainingDataSet('dmd_data_daily_170112.txt')
meterids = meterdata.id.unique()
singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
sortedSingleMeterData = singleMeterData.sort_values(["ts","id","val"],ascending=[1,0, 0])
addedMissingDates=addMissingDates(sortedSingleMeterData,'ts')
timeseries=addedMissingDates
impute_TS=imputeTS(timeseries, 7)


