from source.Dataset import trainingDataSet


def dailyPattern(tsMeterData, movingAverage, noOfDays):
    tsMeterData=tsMeterData.tolist()
    dpwma = []
    i = 1
    for i in range(0, len(tsMeterData) + 1):
        if i > noOfDays:
            dpwma.append(tsMeterData[i - noOfDays] / movingAverage[i - noOfDays])
        else:
            dpwma.append(movingAverage[i])
        i += 1
    return dpwma


def main():
    from source.MovingAverage import movingAverage
    # Run to test the above function
    meterdata = trainingDataSet("input/dmd_data_daily_170112.txt")
    singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
    sortedSingleMeterData = singleMeterData.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
    timeseries = singleMeterData.val
    movingAverage = movingAverage(timeseries, 7)
    basevalues = dailyPattern(timeseries, movingAverage=movingAverage, noOfDays=7)
    # print basevalues

if __name__=='__main__':
    pass