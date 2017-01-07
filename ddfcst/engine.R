ts_model <- function(train_data_set, test_data_set){
  
  
}

ts_forecast <- function(train_data_set, test_data_set){
  library(data.table)
  library(psych)
  library(plotrix)
  library(reshape)
  library(corrplot)
  
  daily_data <- read.csv("temp_dmd_data_daily.txt",header = FALSE, col.names = c("id","dates","value"),sep = "\t")
  str(daily_data)
  daily_data_sorted <- daily_data[order(daily_data$id,daily_data$dates),]
  daily_data_sorted$ts1 <- as.POSIXct(x = daily_data_sorted$dates, format = "%Y-%m-%d")
  
  data_ts <- cast(daily_data_sorted, id~ts1)
  correlation_matrix <- cor((data_ts),use = "pairwise.complete.obs",method = "pearson")
  correlation_matrix[which(is.na(correlation_matrix))] <- 0
  colm_truncate <- correlation_matrix[,na.omit(correlation_matrix)]
  corrplot(correlation_matrix,method = "shade", is.corr = FALSE,type="upper")
  plot(hclust(dist(abs(na.omit(correlation_matrix)))))
  write.csv(file = "correlation.csv",correlation_matrix)
  
  
  
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