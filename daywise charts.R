#install.packages("psych")
#install.packages("plotrix")
#install.packages("data.table")

library(data.table)
library(psych)
library(plotrix)

setwd("C:/jp/ml/20161218")

head(meterdata, 10)

sorteddata <- meterdata[order(meterdata$id, meterdata$ts),]

sorteddata$ts1 <-
  as.POSIXct(x = sorteddata$ts, format = "%Y-%m-%d")
head(sorteddata)

sorteddata2 <-
  setDT(sorteddata,
        keep.rownames = TRUE,
        check.names = FALSE)
sorteddata2[, prevVal := shift(val), by = id]
head(sorteddata2)
sorteddata2[, increment := val - prevVal]
head(sorteddata2)


#Single point plot
meterid <- '3E31B710-98D9-4733-A150-8AE7720855FE'
datatoplot <-
  sorteddata2[id == meterid & ts1 > "2016-11-27"]

str(datatoplot)

meterids <- unique(sorteddata$id)

pdf(file = "myout.pdf")
for (meterid in meterids)
{
  print(meterid)
  datatoplot <- sorteddata2[id == meterid & ts1 > "2016-11-26"]
  if (nrow(datatoplot) > 0)
  {
    plot(
      datatoplot$ts1,
      datatoplot$val,
      type = "l",
      main = meterid,
      ylab = "Reading",
      xlab = "Time"
    )
    # highlimit = quantile(
    #   x = datatoplot$increment,
    #   probs = c(0.999),
    #   na.rm = TRUE,
    #   names = FALSE
    # )
    # lowlimit = quantile(
    #   x = datatoplot$increment,
    #   probs = c(0.001),
    #   na.rm = TRUE,
    #   names = FALSE
    # )
    #
    #
    # plot(
    #   datatoplot$ts1,
    #   datatoplot$increment,
    #   type = "l",
    #   main = meterid,
    #   ylab = "Increment",
    #   xlab = "Time",
    #   ylim = c(lowlimit, highlimit)
    # )
  }
}

dev.off()
