from Dataset import trainingDataSet
import pandas as pd
from datetime import datetime
# from Main import filename

def missingDates(data, dateCol):
    # sorted_single_meter_data = data.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
    # timeDf : copy of dataset['ts'] column
    timeDf =pd.to_datetime(data.iloc[0:][dateCol])
    availabledates=[]
    for dates in timeDf:
        availabledates.append(dates)
    # start: fisrst date in the sorted date. end: last date in sorted date
    start = datetime.strptime(data.iloc[0][dateCol], "%Y-%m-%d")
    end = datetime.strptime(data.iloc[len(data) - 1][dateCol], "%Y-%m-%d")
    # delta: difference between start and end date
    delta = end - start
    alldays = pd.date_range(start, periods=delta.days,freq='D')
    alldays = pd.to_datetime(alldays,"%Y-%m-%d")
    count=0
    missingDates = []
    for day in alldays:
        if day not in availabledates:
            missingDates.append(day)
    return missingDates

def addMissingDates(data, dateCol):
    missingdates = missingDates(data,'ts')
    #get the meterid from data
    meterid=data.iloc[0]['id']
    id,ts,val= [],[],[]
    #append all the missing data
    for date in missingdates:
        tempDate = pd.to_datetime(date, format="%Y-%m-%d %H:%M:%S")
        tempDate = datetime.strftime(tempDate, "%Y-%m-%d")
        id.append(meterid)
        ts.append(tempDate)
        val.append(None)
    #dataframe to hold the missing values
    df=pd.DataFrame({'id':id,'ts':ts,'val':val})
    #mergeData: combine missing data with original data
    mergedata = pd.DataFrame(data.append(df))
    #sort the data base on time
    mergedata.sort_values(by='ts',ascending=True,inplace=True)
    return mergedata

def main():
    # Run to test the above function
    meterdata = trainingDataSet(filename)
    meterids = meterdata.id.unique()
    single_meter_data = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
    # single_meter_data = meterdata[meterdata['id'] == "18D7776E-13C1-4591-8906-18DEC7F04442"]
    sorted_single_meter_data = single_meter_data.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
    timeseries = single_meter_data.val
    missing_dates=missingDates(sorted_single_meter_data,'ts')
    print (missing_dates)
    add_missing_dates=addMissingDates(sorted_single_meter_data,'ts')
    print (add_missing_dates)

if __name__=='__main__':
    pass