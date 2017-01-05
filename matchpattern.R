meterid = "52D61DBC-595E-4E10-BA46-9EF4EE0650C2"
mtr.id.data = sorteddata2[id == meterid & ts1 > "2016-11-26",]

window=7
step=1
data=mtr.id.data
j<- getSlidingWindows(data, window, step)

j$v1 <- c(44.39583, 30.73958, 4.03125, 0, 19.73958, 20.30769, 16.17708)

C4<- cor(na.omit(j), use = "pairwise.complete.obs", method = "kendall")
