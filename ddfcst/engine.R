ts_model <- function(train_data_set, test_data_set){
  
  
}

timeseriesHclustUsingCorrelation <- function(trainDataSet){
  
  # distanceMatrix <- distanceMatrixCorr(dataset)
  # numOfClust = 15
  # tsHclust(distanceMatrix, numOfClust = numOfClust)
  # 
  # return(distance)
}


tsHclust <- function(distance, numOfClust) {
  pdf(file = "dendogram.pdf")
  hc <- hclust(distance,method="complete")
  plot(hc, cex = 0.25, hang = -1, main="Dissimilarity = 1 - Correlation", xlab="")
  rhc <- rect.hclust(hc, k = numOfClust, border = 2)
  dev.off()
  return(rhc)
}

distanceMatrixCorr <- function(dataset){
  dissimilarity <- 1 - abs(cor(t(timeseries_meter_data),use = "pairwise.complete.obs",method = "pearson"))
  distance <- as.dist(dissimilarity)
  return(distance)
}



ts_correlation <- function(ts_data,method){
  correlation_matrix <- cor((ts_data),use = "pairwise.complete.obs",method = "pearson")
  #Replace NA with 0 
  correlation_matrix[which(is.na(correlation_matrix))] <- 0
  correlation_removed_na <- correlation_matrix[,na.omit(correlation_matrix)]
  return(correlation_removed_na)
}


model_validation <- function(model){
  
}