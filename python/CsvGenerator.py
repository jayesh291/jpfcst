from datetime import datetime

import pandas as pd


def generator_csv(file_name,data):
    now = datetime.now()
    val = "%s%s%s%s%s%s" % (now.year, now.month, now.day, now.hour, now.month, now.second)
    file_name = file_name + val + ".csv"
    df=pd.DataFrame(data)
    csv=df.to_csv(index=False)
    with open(file_name,'wb') as file:
        file.write(csv)
    file.close()

