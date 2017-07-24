from Dataset import trainingDataSet
from CsvGenerator import generator_csv
from DatesUtil import missingDates
import pandas as pd

def summary_of_meters(meterids):
    summary_meter=[]
    meterdata = trainingDataSet('input/dmd_data_daily_170112.txt')
    for meters in meterids:
        single_meter_data=meterdata[meterdata['id'] == meters]
        sorted_single_meter_data = single_meter_data.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
        total_missing_days=len(missingDates(sorted_single_meter_data,"ts"))
        summary_meter.append([meters,len(sorted_single_meter_data),total_missing_days])
    generator_csv("out"+"/"+"summery_meter",summary_meter)

def pre_processing(meterdata):
    meter_id = []
    number_of_days=[]
    meter_len=[]

    meterids = meterdata.id.unique()
    for meters in meterids:
        single_meter_data = meterdata[meterdata['id'] == meters]
        # single_meter_data = meterdata[meterdata['id'] == '3C5A1042-D1B2-4301-891D-5F9C66927280']
        sorted_single_meter_data = single_meter_data.sort_values(["ts", "id", "val"], ascending=[1, 0, 0])
        # meter_id.append('3C5A1042-D1B2-4301-891D-5F9C66927280')
        meter_id.append(meters)
        number_of_days.append(len(single_meter_data))
        total_missing_days = len(missingDates(sorted_single_meter_data, "ts"))
        meter_len.append(total_missing_days)

    # sum(pd.isnull(df1['col1']))

    # summary_meter.append([meters, total_missing_days])
    summary_meter_series=pd.DataFrame(meter_id,columns=["id"])
    summary_meter_series['total_days'] = pd.Series(number_of_days)
    summary_meter_series['missing_days']=pd.Series(meter_len)
    # summary_meter_series.set_index(['id'],inplace=True)
    # print summary_meter_series.loc[0]['missing_days']
    summary_meter_series['percentage_missing_date'] = summary_meter_series['missing_days'] / summary_meter_series[
        'total_days'] * 100
    return summary_meter_series
    # print summary_meter_series

def too_many_zero_values():
    meterdata = trainingDataSet('input/dmd_data_daily_170112.txt')
    meterids = meterdata.id.unique()
    too_many_zero_values=[]
    for meter in meterids:
        single_meter_data=(meterdata[meterdata['id'] == meter])
        if len(single_meter_data[single_meter_data['val'] == 0.00000]) / len(single_meter_data) > 0.1:
            too_many_zero_values.append(meter)
    return too_many_zero_values


def main():
    meterdata = trainingDataSet('input/dmd_data_daily_170112.txt')
    single_meter_data = meterdata[meterdata['id'] == '3C5A1042-D1B2-4301-891D-5F9C66927280']
    single_meter_data = meterdata[meterdata['id'] == "0071CFB0-D92D-4035-ABA6-1AB961E4F573"]
    single_meter_data = meterdata[meterdata['id'] == "18D7776E-13C1-4591-8906-18DEC7F04442"]
    single_meter_data = meterdata[meterdata['id'] == "04764786-1E05-4DF6-9EC0-415BEBF13E00"]
    print(too_many_zero_values(single_meter_data))
    meterids = meterdata.id.unique()
    summary_of_meters(meterids)
    print(too_many_zero_values())

if __name__ == '__main__':
    pass

