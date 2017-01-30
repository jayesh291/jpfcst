

representativeTimeSeries <- function(clusters,timesereisdata,meterdata){
  
  tsData <- t(timesereisdata)
  representiveSereisIDs <- c()
  for(i in 1: length(clusters)){
    # subset data
    grpno <- c(grpno, unlist(x = clusters[[i]], recursive = T, use.names = T))
    id <- names(clusters[[i]])
    mtr.clstr.i <- tsData[, c(id)]
    
    #get group wise correlations
    C2 <-  cor(na.omit(mtr.clstr.i), use = "pairwise.complete.obs", method = "kendall")
    C3 <- abs(C2)
    # C3$avg <- rowMeans(C3)
    write.csv(C3, paste0("correlations", i ,".csv"))
    
    
    #get representative timeseries id for each group
    cl.mns <- colMeans(C3)
    rep.mtr.id <- names(cl.mns)[match(max(cl.mns), cl.mns)]
    rep.ids <- c(rep.ids, rep.mtr.id)
    representiveSereisIDs <- c(representiveSereisIDs,rep.ids)
    #plot groups
    # filter.cluster <- (meterdata$id %in% c(id))
    plotmeters(meterdata[which(filter.cluster), ], paste0("outs/correlations", i , "-", rep.mtr.id, ".pdf"))
    # 
  }
    return(unique(representiveSereisIDs))
  
}