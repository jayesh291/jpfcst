from Dataset import trainingDataSet
import numpy as np

def maxVector(mdata, originalTs, cyclePeriod):
    maxVector = []
    for i in range(0, len(mdata)+1):
        if i==0 or i==1:
            maxVector.append(max(originalTs[i:]))
        elif i <= len(originalTs):
            maxVector.append(max(originalTs[0:(i - 1)]))
        else:
            maxVector.append(max(originalTs[0:len(originalTs)]))
    return maxVector

def maxNormalization(x, y, cyclePeriod):
    x=np.array(x)
    y=np.array(y)
    if np.any(x) < np.any(y):
        return x
    else:
        return y * (x * (cyclePeriod / 10))


# run to test the function
meterdata = trainingDataSet('dmd_data_daily_170112.txt')
singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
sortedSingleMeterData = singleMeterData.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
timeseries = sortedSingleMeterData.val
max_vector=maxVector(timeseries, timeseries, 7)