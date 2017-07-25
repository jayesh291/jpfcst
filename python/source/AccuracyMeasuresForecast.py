'''
Class to measure forecast accuracy : MAPE
'''

import numpy as np


def calculate_mape(actuals, predictions, look_back):
    '''
    Calculate Mean Absolute Percentage Error (MAPE)
    :param actuals: Actual Values
    :param predictions: Predicted Values
    :param look_back: Evaluation Period
    :return: MAPE Value
    '''
    y_true = 0
    y_pred = 0
    mape = 0.0

    for i in range(look_back):
        y_true += float(actuals[i])
        y_pred += float(predictions[i])

    mape = round(np.mean((abs((y_true - y_pred) / y_true)) * 100), 2)

    return mape


def calculate_mape_weekly_incremental(actuals, predictions, look_back):
    '''
     Calculate Mean Absolute Percentage Error (MAPE)
    :param actuals: Actual Values
    :param predictions: Predicted Values
    :param look_back: Evaluation Period
    :return: Weekly Incremental MAPE Values
    '''
    y_true1 = 0
    y_pred1 = 0
    MAPE = []
    count = 0

    for i in range(look_back):
        y_true1 += float(actuals[i])
        y_pred1 += float(predictions[i])
        count += 1
        # if i == look_back:
        if (count % 7) == 0:
            MAPE.append(round(np.mean((abs((y_true1 - y_pred1) / y_true1)) * 100), 2))
    if (count % 7) != 0:
        MAPE.append(round(np.mean((abs((y_true1 - y_pred1) / y_true1)) * 100), 2))

    return MAPE

def calculate_mape_weekly(actuals, predictions, look_back):
    '''
     Calculate Mean Absolute Percentage Error (MAPE)
    :param actuals: Actual Values
    :param predictions: Predicted Values
    :param look_back: Evaluation Period
    :return: Weekly MAPE Values
    '''
    y_true = 0
    y_pred = 0
    MAPE = []
    count = 0

    for i in range(look_back):
        y_true += float(actuals[i])
        y_pred += float(predictions[i])
        count += 1
        if (count % 7) == 0:
            MAPE.append(round(np.mean((abs((y_true - y_pred) / y_true)) * 100), 2))
            y_true = 0
            y_pred = 0
    if (count % 7) != 0:
        MAPE.append(round(np.mean((abs((y_true - y_pred) / y_true)) * 100), 2))

    return MAPE