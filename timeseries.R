#install.packages("reshape","corrplot","data.table","psych","plotrix")


rm(list = ls())

setwd("C:/jp/git/jpfcst/jpfcst")

library(reshape)
library(corrplot)
library(data.table)
library(psych)
library(plotrix)

source("C:/jp/git/jpfcst/jpfcst/functions.R")
source("C:/jp/git/jpfcst/jpfcst/dataset.R")
source("C:/jp/git/jpfcst/jpfcst/preprocess.R")
source("C:/jp/git/jpfcst/jpfcst/meterdata.R")
source("C:/jp/git/jpfcst/jpfcst/matchpattern.R")
source("C:/jp/git/jpfcst/jpfcst/forecast.R")

