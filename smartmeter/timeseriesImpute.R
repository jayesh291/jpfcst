#  Customized implementaion

imputeFromNumOfDaysBefore <- function(timeseries,days){
  i=1
  while(i < length(timeseries)){
    if(is.na(timeseries[i]) ){
      if(i < days){
        if(i == 1){
          timeseries[i] <- mean(timeseries,na.rm = TRUE)
        }else{
          message(" i ", i, " i+dyas ", (i+days), " - ",timeseries[i+days])
          if(!is.na(timeseries[i+days])){
            timeseries[i+days]
          }
          if(!is.na(timeseries[i+(days*2)])){
          timeseries[i] <-  timeseries[i+(days*2)]
          }
          if(!is.na(timeseries[i+(days*3)])){
            timeseries[i] <-  timeseries[i+(days*3)]
          }
        }        
      }else{
        if(!is.na(timeseries[i-days])){
          timeseries[i-days]
          message("1")
        }
        if(!is.na(timeseries[i+(days*2)])){
          timeseries[i] <-  timeseries[i+(days*2)]
          message("2")
        }
        if(!is.na(timeseries[i+(days*3)])){
          timeseries[i] <-  timeseries[i+(days*3)]
          message("3")
        }
        if(!is.na(timeseries[i+(days*4)])){
          timeseries[i] <-  timeseries[i+(days*4)]
          message("3")
        }
      }
    }
    i <- i+1
  }
  return(timeseries)
}
# df <- singleMeterData
# sevanDays <- imputeFromNumOfDaysBefore(df$val,7)
# twoWeeks <- imputeFromNumOfDaysBefore(df$val,14)
# 
# plot(0,0,xlim = c(1,length(df$val)),ylim = c(min(df$val,na.rm = TRUE),max(df$val,na.rm = TRUE)),type = "n",xlab = meterid)
# lines(df$val,type = 'l',col="blue")
# lines(sevanDays,type = 'l', col = "red")
# lines(twoWeeks,type = 'l', col = "green")




