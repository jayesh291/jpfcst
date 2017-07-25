


import  os

# from CustomLogger import CustomLogger

# logger = CustomLogger("test").logger

dir = os.getcwd()
print(dir)

import os.path

# pardir = os.pardir(dir)
# print(pardir)
print (os.path.abspath(os.path.join(dir, os.pardir)))
# print (os.path.abspath(os.path.join(dir, )))


print(" -- ",os.path.basename(dir))

# logger.info(" working dir: %s " %dir)
# logger.info(" Test run")

