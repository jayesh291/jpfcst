
#transpose to have dates as columns
mtr.dtscol <- cast(mtr.f, id ~ ts, value = "val")
write.csv(mtr.dtscol, file = "./outs/transposed.csv")

#transpose to have meters as columns
mtr.mtrcol <- t(mtr.dtscol)
C1 <- cor(mtr.mtrcol, use = "pairwise.complete.obs", method = "kendall")

write.csv(C1, "./outs/correlations.csv")

# rownames(C1) <- c(1:nrow(C1))
# colnames(C1) <- c(1:ncol(C1))

#cluster and plot
hc <- hclust(dist(C1))

pdf("./outs/dendogram.pdf")
plot(hc, cex = 0.2, hang = -1)
rhc <- rect.hclust(hc, k = 15, border = 2)
dev.off()

#get representative timeseries for each cluster
grpno <- NULL
rep.ids <- NULL
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
    mtr.clstr.i <- mtr.mtrcol[, c(id)]
    
    #get group wise correlations
    C2 <-
      cor(mtr.clstr.i, use = "pairwise.complete.obs", method = "kendall")
    C3 <- abs(C2)
    # C3$avg <- rowMeans(C3)
    write.csv(C3, paste0("./outs/correlations", i , ".csv"))
    
    #get representative timeseries id for each group
    cl.mns <- colMeans(C3)
    rep.mtr.id <- names(cl.mns)[match(max(cl.mns), cl.mns)]
    #rep.ids <- c(rep.ids, rep.mtr.id)
    rep.ids[i] <- rep.mtr.id
    
    #plot groups
    filter.cluster <- (mtr.f$id %in% c(id))
    plotmeters(mtr.f[which(filter.cluster),],
               paste0("./outs/correlations", i , "-", rep.mtr.id, ".pdf"))
  }
}

print(rep.ids)


