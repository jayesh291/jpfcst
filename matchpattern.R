#get first representative id
grp = 5
mmbr = 1
window = 7
step = 1

for(grp in 1:length(rhc)){
  for(mmbr in 1:length(rhc[[grp]])){
    repid = rep.ids[grp]
    targetid = names(rhc[[grp]])[mmbr]
    rep.id.data = mtr.f2[id == repid, ]
    j <- getSlidingWindows(rep.id.data, window, step)
    
    j[, 1] <- mtr.f3[id == targetid, val]
    
    C4 <- cor(j, use = "pairwise.complete.obs", method = "kendall")[,1]
    C4[C4 == 1] <- 0
    matcheddate <- names(C4[match(max(C4), C4)])
    
    write.csv(C4, paste0("./outs/correlations-g", grp,"-m",mmbr , ".csv"))
    
  }
}








