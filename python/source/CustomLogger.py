import logging
import platform
from logging.handlers import RotatingFileHandler
import os
class CustomLogger:
    def __init__(self,logFile):

        self.filename="../log/log.log"

        self.logger=logging.getLogger(logFile)
        formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        logging.basicConfig(filename=self.filename, filemode='a', level=logging.DEBUG,
                            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', \
                            datefmt='%m/%d/%Y %I:%M:%S %p')

        handler = RotatingFileHandler(self.filename, maxBytes=5 * 1024 * 1024, backupCount=20)

        consoleHandler = logging.StreamHandler()
        consoleHandler.setFormatter(formatter)

        self.logger.addHandler(handler)
        self.logger.addHandler(consoleHandler)
