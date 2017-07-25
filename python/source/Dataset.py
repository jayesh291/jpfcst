import pandas as pd
from source.CustomLogger import CustomLogger
logger = CustomLogger("Main").logger

def trainingDataSet(traindata_filename):
    # Reading file:
    cols = ['id', 'ts', 'val']
    try:
        traindata_file = pd.read_csv(traindata_filename, sep='\t', names=cols, encoding='latin-1')
        # sort file based on id and ts
        sorteddata = traindata_file.sort_values(['id', 'ts'], ascending=[1, 0])
    except FileNotFoundError as fileNotFoundError:
        logger.log(msg="File not found %s"%fileNotFoundError,level=20)
    return sorteddata

# meterdata = trainingDataSet('..\input\dmd_data_daily_170112.txt')
# print(meterdata)
