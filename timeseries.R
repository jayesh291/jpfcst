rm(list = ls())

setwd("C:/jp/ml/20161218")

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
