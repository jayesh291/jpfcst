
#transpose to have dates as columns
mtr.dtscol <- cast(mtr.f, id ~ ts, value = "val")
write.csv(mtr.dtscol, file = "./outs/transposed.csv")

#transpose to have meters as columns
mtr.mtrcol <- t(mtr.dtscol)

mtr_mtrcol_scale <- scale(mtr.mtrcol)

mtr_dtscol_scale <- t(mtr_mtrcol_scale)

# rownames(C1) <- c(1:nrow(C1))
# colnames(C1) <- c(1:ncol(C1))

dists <- dist(mtr_dtscol_scale, method =  "euclidian", upper = F, diag = F)
write.csv(as.matrix(dists), "./outs/dists.csv")

par(bg="grey90");                                                   # Set background to gray.
plot(dists);                                                           # Plot original database.
dev.off()

# Compute DBSCAN using fpc package
set.seed(123)
db <- fpc::dbscan(dists, eps = 3, MinPts = 3, showplot = 2);                                    # Calls DBSCAN routine (eps = 10 and MinPts is set to its default, which is 5).
db;                                                                 # Shows DBSCAN result.

# Plot DBSCAN results
plot(db, dists, main = "DBSCAN", frame = FALSE)
dev.off()

plot(db$cluster == 0)
plot(dists, col=db$cluster)


pl[ds$cluster==1,]

#cluster and plot
# hc <- hclust(dists)
# 
# pdf("./outs/dendogram.pdf")
# plot(hc, cex = 0.2, hang = -1)
# rhc <- rect.hclust(hc, k = 15, border = 2)
# dev.off()

#get representative timeseries for each cluster
grpno <- NULL
rep.ids <- NULL
i = 1
for (i in 1:length(rhc)) {
  # subset data
  grpno <-
    c(grpno, unlist(
      x = rhc[[i]],
      recursive = T,
      use.names = T
    ))
  id <- names(rhc[[i]])
  if (length(id) > 1) {
    mtr.clstr.i <- mtr_dtscol_scale[c(id), ]
    
    #get group wise correlations
    C3 <-  as.matrix(dist(mtr.clstr.i, method =  "manhattan"))
    write.csv(C3, paste0("./outs/correlations", i , ".csv"))
    
    #get representative timeseries id for each group
    cl.mns <- colMeans(C3)
    rep.mtr.id <- names(cl.mns)[match(min(cl.mns), cl.mns)]
    rep.ids[i] <- rep.mtr.id
    
    #plot groups
    filter.cluster <- (mtr.f$id %in% c(id))
    plotmeterswithrep(mtr.data = mtr.f[which(filter.cluster),],
               filename = paste0("./outs/correlations", i , "-", rep.mtr.id, ".pdf"), rep.mtr.id = rep.mtr.id)
  }
}

print(rep.ids)


