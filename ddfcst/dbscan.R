

library("fpc")
# Compute DBSCAN using fpc package
# set.seed(123)
meterdata <- trained_data_set(train_data_set_filename)
timeseriesData <- preprocess(meterdata)
timeseriesData[is.na(timeseriesData)] <- 0.00001
str(timeseriesData)
# dst <- dist(t(timeseriesData),method = "euclidean")
# install.packages("cluster")
# library("cluster")
dds <- daisy(timeseriesData,metric = c("euclidean","manhattan","gower"))
dbd <- fpc::dbscan(dds, eps = 0.2, MinPts = 2,scale = FALSE)
dbd$cluster
table(dbd$cluster)
plot(df1[dbd$cluster > 0,], col=dbd$cluster[dbd$cluster>0])
# library("factoextra")
fviz_cluster(dbd, timeseriesData, stand = FALSE, frame = FALSE, geom = "point")
fviz_cluster(dbd, timeseriesData, geom = "point")
table(dbd$cluster)



df1 <- as.data.frame(timeseriesData[, 2:5])
str(df1)
db <- fpc::dbscan(df1, eps = 0.59, MinPts = 2)
db$cluster
table(db$cluster)
plot(df1[db$cluster > 0,], col=db$cluster[db$cluster>0])
library("factoextra")
fviz_cluster(db, df1, stand = FALSE, frame = FALSE, geom = "point")
fviz_cluster(db, timeseriesData, geom = "point")
table(db$cluster)
head(df1[db$cluster == 0,])
timeseriesData[1:20,2:3]
