#get first representative id
grp = 5
mmbr = 1
window = 7
step = 1
groupcorrelations = NULL
columnnames = NULL

for (grp in 1:length(rhc)) {
  if (length(rhc[[grp]]) > 1) {
    for (mmbr in 1:length(rhc[[grp]])) {
      repid = rep.ids[grp]
      targetid = names(rhc[[grp]])[mmbr]
      rep.id.data = mtr.f2[id == repid, ]
      j <- getSlidingWindows(rep.id.data, window, step)
      
      j[, 1] <- mtr.f3[id == targetid, val]
      
      C4 <-
        cor(j, use = "pairwise.complete.obs", method = "kendall")[, 1]
      C4[C4 > 0.99999999] <- 0
      matcheddate <- names(C4[match(max(C4, na.rm = TRUE), C4)])
      
      C4 <- c(C4, "matcheddate" = matcheddate)
      
      columnnames <- c(columnnames, paste0("g", grp, "-m", mmbr))
      
      if (is.null(groupcorrelations)) {
        groupcorrelations <- cbind(C4)
      }
      else {
        groupcorrelations <-
          cbind(groupcorrelations, C4[match(rownames(groupcorrelations), names(C4))])
      }
      
      colnames(groupcorrelations) <- columnnames
      
    }
    write.csv(groupcorrelations, "./outs/groupcorrelations.csv")
  }
}
