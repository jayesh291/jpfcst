from Dataset import trainingDataSet


def maxVector(mdata, originalTs, cyclePeriod):
    # mdata<- singleMeterData$val
    # originalTs <- singleMeterData$val
    # cyclePeriod <- 7
    maxVector = []
    for i in range(2, len(mdata)):
        if i > cyclePeriod:
            if i <= len(originalTs):
                maxVector.append(max(originalTs[2:(i - 1)]))
            else:
                maxVector.append(max(originalTs[2:len(originalTs)]))
        else:
            maxVector.append(max(originalTs[1:i]))
    return (maxVector)


def maxNormalization(x, y, cyclePeriod):
    if x < y:
        return x
    else:
        return y * (x * cyclePeriod / 10)


# run to test the function
meterdata = trainingDataSet('dmd_data_daily_170112.txt')
singleMeterData = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
sortedSingleMeterData = singleMeterData.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
timeseries = sortedSingleMeterData.val
data = sortedSingleMeterData.to_csv()
print(maxVector(timeseries, timeseries, 7))
