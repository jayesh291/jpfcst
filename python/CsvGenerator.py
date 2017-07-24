from datetime import datetime
import pandas as pd
from CustomLogger import CustomLogger

def generator_csv(file_name,data):
    now = datetime.now()
    val = "%s%s%s%s%s%s" % (now.year, now.month, now.day, now.hour, now.month, now.second)
    file_name += val + ".csv"
    df=pd.DataFrame(data)
    csv=df.to_csv(index=False)
    try:
        with open(file_name,'w') as file:
            file.write(csv)
    except FileNotFoundError as fileNotFoundError:
        CustomLogger(file_name).logger.info(fileNotFoundError)
    finally:
        file.close()
