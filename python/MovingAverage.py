import numpy as np
from Dataset import trainingDataSet


# def movingAverage(unitData, n):
#     ma=[]
#     for j in range(1,len(unitData)+1):
#         if j > (n+1):
#             ma.append(unitData[(j-n):(j-1)].mean())
#         else:
#             ma.append(unitData[j])
#     return ma


# Moving avg excluding the day, for current use prev n days avg
# unitData <- tsMeterData
# n = 7
def movingAverage(timeseries, n):
    ma = []
    for j in range(1, len(timeseries) + 1):
        if j > (n + 1):
            ma.append(np.mean(timeseries[(j - n - 1):(j - 1)]))
        else:
            ma.append(timeseries[j])
    return ma


def save_data(data, fileName):
    with open(fileName, "w") as file:
        file.write(data)


# run to test the function
meterdata = trainingDataSet('dmd_data_daily_170112.txt')
singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
sortedSingleMeterData = singleMeterData.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
timeseries = sortedSingleMeterData.val

# dfm.index = range(1,len(dfm) + 1)
sortedSingleMeterData.index = range(1, len(sortedSingleMeterData) + 1)
data = sortedSingleMeterData.to_csv()
# save_data(data,fileName="singleMeterData.csv")
# df = sortedSingleMeterData.set_index(np.(len(sortedSingleMeterData.index)))

# df2.set_index(np.arange(len(df2.index)))


ma = movingAverage(sortedSingleMeterData.val, 7)

import pickle

with open('outfile1.csv', 'w') as fp:
    fp.write("\n".join(map(lambda x: str(x), ma)))
    fp.close()

    # fp.write(ma)
    # .join([str(i) for i in value_list])
