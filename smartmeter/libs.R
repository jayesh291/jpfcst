ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}
# usage
packages <- c("ggplot2", "plyr", "reshape2", "RColorBrewer", "scales", "grid")
packages <- c(packages,"data.table","psych","plotrix","corrplot","dtw","zoo","proxy")
packages <- c(packages,"forecast")

ipak(packages)




library(data.table)
library(psych)
library(plotrix)
library(reshape)
library(corrplot)
library(ggplot2)
library(dtw)
library(zoo)
library(proxy)
library(forecast)
