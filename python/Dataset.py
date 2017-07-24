import pandas as pd

def trainingDataSet(traindata_filename):
    # Reading file:
    cols = ['id', 'ts', 'val']
    traindata_file = pd.read_csv(traindata_filename, sep='\t', names=cols, encoding='latin-1')
    # sort file based on id and ts
    sorteddata = traindata_file.sort_values(['id', 'ts'], ascending=[1, 0])
    return sorteddata

# meterdata = trained_data_set('dmd_data_daily_170112.txt')
# print(meterdata)
