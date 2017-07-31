import unittest
import pandas as pd
import numpy as np
from source.BaseValue import baseValueForTsForecast
from source.MovingAverage import movingAverage
from source.DailyPattern import dailyPattern
from source.Normalization import maxVector
from source.ScaleFactor import minVector
from source.ScaleFactor import minValueAvg
from source.ScaleFactor import minValueWeeklyTrend
from source.AccuracyMeasuresForecast import calculate_mape

from decimal import *
getcontext().prec = 4

def addRoundList(input_list):
    return ["%.4f" % e for e in input_list ]

cyclePeriod=7

true_data =pd.read_csv('TestFile.csv')

true_bv = (true_data.base_values).tolist()

true_ma= (true_data.moving_average).tolist()

true_dp=(true_data.daily_pattern).tolist()

true_mv=(true_data.max_vector).tolist()

true_min_v=(true_data.min_vector).tolist()

true_normalization=(true_data.normalization).tolist()

true_base_prediction = true_data.base_prediction

true_min_vector=(true_data.min_vector).tolist()

true_minValueWeeklyTrend=(true_data.minValueWeeklyTrend).tolist()

true_avgMinValues=(true_data.avgMinValues).tolist()

true_prediction=(true_data.prediction).tolist()

class TestUM(unittest.TestCase):

    def setUp(self):
        pass

    def test_baseValueFunction(self):
        self.assertListEqual(addRoundList(baseValueForTsForecast(true_data.val1,7,3)[0:len(true_bv)-1]),addRoundList(true_bv[0:len(true_bv)-1]))
        # self.assertListEqual(baseValueForTsForecast(true_data.val1, 7, 3)[0:len(true_bv) - 1],true_bv[0:len(true_bv) - 1],4)

    def test_movingAverage(self):
        self.assertEqual(addRoundList(movingAverage(true_data.val1,7)[0:len(true_bv)-1]),addRoundList(true_ma[0:len(true_ma)-1]))

    def test_dailyPattern(self):
        self.assertEqual(addRoundList(dailyPattern(true_data.val1,true_ma,cyclePeriod)[0:len(true_bv)-1]),addRoundList(true_dp[0:len(true_dp)-1]))

    def test_maxVector(self):
        self.assertEqual(addRoundList(maxVector(true_data.val1,true_data.val1,cyclePeriod)[0:len(true_bv)-1]),addRoundList(true_mv[0:len(true_mv)-1]))

    def test_normalization(self):
        self.assertEqual(addRoundList(np.array(true_dp)*0.2/np.array(true_mv)+0.9),addRoundList(true_normalization))

    def test_base_prediction(self):
        self.assertEqual(addRoundList(np.array(true_bv) * np.array(true_normalization)),addRoundList(true_data.base_prediction))

    def test_minVector(self):
        self.assertEqual(addRoundList(minVector(true_base_prediction, cyclePeriod)[0:len(true_bv)-1]),addRoundList(true_min_vector)[0:len(true_bv)-1])

    def test_minValueWeeklyTrend(self):
        self.assertEqual(addRoundList(minValueWeeklyTrend(true_min_vector)[0:len(true_bv)-1]),addRoundList(true_data.minValueWeeklyTrend)[0:len(true_bv)-1])

    def test_minValueAvg(self):
        self.assertEqual(addRoundList(minValueAvg(true_minValueWeeklyTrend)[0:len(true_bv)-1]),addRoundList((true_data.avgMinValues)[0:len(true_bv)-1]))

    def test_prediction(self):
        self.assertEqual(addRoundList(true_base_prediction * true_avgMinValues),addRoundList(true_data.prediction))

    def test_accuracy_formulae(self):
        inputData = pd.read_csv('MAPE_V2.csv')
        getcontext().prec=1
        calMape =calculate_mape(inputData.Actual,inputData.Forecast,21)
        self.assertEqual(calMape,27.5)


import sys
if __name__ == "__main__":
    suite = unittest.TestSuite()
    if len(sys.argv) == 1:
        suite = unittest.TestLoader().loadTestsFromTestCase(TestUM)
    else:
        for test_name in sys.argv[1:]:
            suite.addTest(TestUM(test_name))
            unittest.TextTestRunner(verbosity=2).run(suite)

suite = unittest.TestLoader().loadTestsFromTestCase(TestUM)
unittest.TextTestRunner(verbosity=2).run(suite)
