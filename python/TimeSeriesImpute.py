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

    timeseries1=timeseries1.reset_index()
    del timeseries1['index']
    timeseries1['val1'] = pd.Series(timeseries)
    return timeseries1

def main():
    # run to test the function
    meterdata = trainingDataSet('input/dmd_data_daily_170112.txt')
    meterids = meterdata.id.unique()
    # singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
    # singleMeterData = meterdata[meterdata['id'] == "04764786-1E05-4DF6-9EC0-415BEBF13E00"]
    singleMeterData=meterdata[meterdata['id'] == "04764786-1E05-4DF6-9EC0-415BEBF13E00"]
    sortedSingleMeterData = singleMeterData.sort_values(["ts","id","val"],ascending=[1,0, 0])
    addedMissingDates=addMissingDates(sortedSingleMeterData,'ts')
    timeseries=addedMissingDates
    impute_TS=imputeTS(timeseries, 7)
    print(impute_TS)

if __name__=='__main__':
    pass