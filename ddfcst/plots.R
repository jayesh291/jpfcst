plotmeters <- function(mtr.data, filename)
{
  pdf(file = filename)
  mtr.data.dt <- na.omit(mtr.data)
  meterids <- unique(mtr.data.dt$id)
  for (meterid in meterids)
  {
    datatoplot <- mtr.data.dt[mtr.data.dt$id == meterid & mtr.data.dt$ts1 > "2016-11-26",]
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
