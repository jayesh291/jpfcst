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
    datatoplot <- mtr.data.dt[id == meterid]
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

plotmeterswithrep <- function(mtr.data, filename, rep.mtr.id)
{
  pdf(file = filename)
  mtr.data$ts1 <- as.POSIXct(x = mtr.data$ts, format = "%Y-%m-%d")
  meterids <- unique(mtr.data$id)
  mtr.data.sort <- mtr.data[order(mtr.data$id, mtr.data$ts1),]
  
  mtr.data.dt <- setDT(mtr.data.sort, keep.rownames = TRUE, check.names = FALSE)
  repdatatoplot <- mtr.data.dt[id == rep.mtr.id]
  
  
  for (meterid in meterids)
  {
    # print(meterid)
    datatoplot <- mtr.data.dt[id == meterid]
    if (nrow(datatoplot) > 0)
    {
      highlimit = max(datatoplot$val, repdatatoplot$val)
      lowlimit = min(datatoplot$val, repdatatoplot$val)
      par(mar = c(5,5,2,5))
      plot(
        datatoplot$ts1,
        datatoplot$val,
        type = "l",
        main = meterid,
        sub = paste0("Rep: ", rep.mtr.id),
        ylab = "Reading",
        xlab = "Time"
        # ,ylim = c(lowlimit, highlimit)
      )
      par(new = T)
      plot(
        repdatatoplot$ts1,
        repdatatoplot$val,
        type = "l",
        col = c("blue"),
        axes = F, xlab=NA, ylab=NA
        
      )
      axis(side = 4)
      mtext(side = 4, line = 3, 'Rep reading', col = "blue")
    }
  }
  dev.off()
}

# mtr.data = mtr.f
# filename = "./outs/test.pdf"
# rep.mtr.id = "DBCCBD51-0CB9-4FAC-846C-A9D35D17AD2A"
# plotmeterswithrep(mtr.data, filename, rep.mtr.id)
# dev.off()

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
