#  Customized implementaion

imputeFromNumOfDaysBefore <- function(timeseries,days){
  timeseries <- singleMeterData$val
  days <- 7
  i=1
  while(i < length(timeseries)){
    if(is.na(timeseries[i]) ){
      if(i <= days){
        for(j in 1:12){
          if(!is.na(timeseries[i+(days*j)])){
            timeseries[i] <-  timeseries[i+(days*j)]
            break
          }
        }
      }else{
            timeseries[i] <-  timeseries[i-days]
        }
    }
    i <- i+1
  }
  return(timeseries)
}


# meterid <- "07d26ce6-8a77-4ca7-ae65-fade8570e58f"
meterid <- "f3523f2e-c5ff-4545-893b-0f3c335161e1"
# meterid <- sample(meterids,1)
# mterid <- "e9e42c5f-c141-4ef1-a203-75672ee58e6b"
# message("meterid : ",meterid)

# testing code
# meterid <- "0eda79b9-53f2-4d24-bb60-5186437d4fe2"
# singleMeterData <- meterdata[meterdata$id == meterid,]
# singleMeterData <- addMissingDates(data = singleMeterData, "ts1")
# df <- singleMeterData
# sevanDays <- imputeFromNumOfDaysBefore(df$val,7)
# par(mfrow=c(1,1))
# plot(df$val,type='l')
# plot(sevanDays,type="l")
# df$val
# sevanDays
# graphics.off()

# twoWeeks <- imputeFromNumOfDaysBefore(df$val,14)
# 
# plot(0,0,xlim = c(1,length(df$val)),ylim = c(min(df$val,na.rm = TRUE),max(df$val,na.rm = TRUE)),type = "n",xlab = meterid)
# lines(df$val,type = 'l',col="blue")
# lines(sevanDays,type = 'l', col = "red")
# lines(twoWeeks,type = 'l', col = "green")




