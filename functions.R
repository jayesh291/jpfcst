plotmeters <- function(mtr.data, filename)
{
  pdf(file = filename)
  mtr.data$ts1 <- as.POSIXct(x = mtr.data$ts, format = "%Y-%m-%d")
  meterids <- unique(mtr.data$id)
  mtr.data.sort <- mtr.data[order(mtr.data$id, mtr.data$ts1),]
  
  mtr.data.dt <- setDT(mtr.data.sort, keep.rownames = TRUE, check.names = FALSE)
  for (meterid in meterids)
  {
    # print(meterid)
    datatoplot <- mtr.data.dt[id == meterid & ts1 > "2016-11-26"]
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
    }
  }
  dev.off()
}


plotmeters(mtr.f, "./outs/test.pdf")


getSlidingWindows <- function(data, window, step){
  total <- length(data[[1]])
  spots <- seq(from=1, to=(total-window), by=step)
  cl.nms <- droplevels(data[1:length(spots),ts])
  r.nms = c(1:window)
  result = table(r.nms)
  for(i in 1:length(spots)){
    result <- cbind(result, (data[spots[i]:(spots[i]+window-1), val]))
  }
  colnames(result) <- c("V1",levels(cl.nms))
  return(result)
}

window=7
step=1
data=mtr.id.data
j<- getSlidingWindows(data, window, step)

