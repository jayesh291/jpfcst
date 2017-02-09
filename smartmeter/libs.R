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
# proxy supports many dist calculation
# <start> 
# "Jaccard" "Kulczynski1" "Kulczynski2" "Mountford" "Fager" "Russel" "simple matching" "Hamman" "Faith"
# "Tanimoto" "Dice" "Phi" "Stiles" "Michael" "Mozley" "Yule" "Yule2" "Ochiai"
# "Simpson" "Braun-Blanquet" "cosine" "eJaccard" "fJaccard" "correlation" "Chi-squared" "Phi-squared" "Tschuprow"
# "Cramer" "Pearson" "Gower" "Euclidean" "Mahalanobis" "Bhjattacharyya" "Manhattan" "supremum" "Minkowski"
# "Canberra" "Wave" "divergence" "Kullback" "Bray" "Soergel" "Levenshtein" "Podani" "Chord"
# "Geodesic" "Whittaker" "Hellinger"
# <end>

# library(forecast)
# library(PerformanceAnalytics)
# library(ggfortify)
# library(dygraphs)
# library(Nclus)
# library(pvclust)
# library(ggplot2)
# library(ggplot)
# library(ROCR)
# library(e1071)
# library(mlbench)
# library(mldeck)
# library(dtw)
# library(plotly)
# library(fpc)
# library(mclust)
# library(xts)
# library(MASS)
# library(caret)
# library(mlbench)
# library(compare)
# library(shiny)
# library(curl)
# library(dplyr)
# library(reshape2)
# library(plyr)
# library(dplyr)
# library(RColorBrewer)

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




