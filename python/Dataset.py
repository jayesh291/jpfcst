import pandas as pd
import numpy as np
from datetime import datetime


def trainingDataSet(traindata_filename):
    # Reading file:
    cols = ['id', 'ts', 'val']
    traindata_file = pd.read_csv(traindata_filename, sep='\t', names=cols, encoding='latin-1')
    # sort file based on id and ts
    sorteddata = traindata_file.sort_values(['id', 'ts'], ascending=[1, 0])
    return sorteddata


def testing_data_set(testdata_filename):
    return ("")


# meterdata = trained_data_set('dmd_data_daily_170112.txt')
# print(meterdata)
