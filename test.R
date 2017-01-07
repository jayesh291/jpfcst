install.packages("party")

cor.prob <- function(X, dfr = nrow(X) - 2) {
  R <- cor(X)
  above <- row(R) < col(R)
  r2 <- R[above]^2
  Fstat <- r2 * dfr / (1 - r2)
  R[above] <- 1 - pf(Fstat, 1, dfr)
  
  cor.mat <- t(R)
  cor.mat[upper.tri(cor.mat)] <- NA
  cor.mat
}

set.seed(123)
data <- matrix(rnorm(100), 20, 5)
cor.prob(data)


correlations <- cor.prob(meters)
write.csv(correlations, "correlations.csv")


(Cl <- cor(longley))
symnum(Cl)



set.seed(42)
M <- matrix(rnorm(40),ncol=4)
head(M)
apply(M, 2, sd)




hc <- hclust(dist(USArrests)^2, "cen")
memb <- cutree(hc, k = 10)
cent <- NULL
for(k in 1:10){
  cent <- rbind(cent, colMeans(USArrests[memb == k, , drop = FALSE]))
}
hc1 <- hclust(dist(cent)^2, method = "cen", members = table(memb))
opar <- par(mfrow = c(1, 2))
plot(hc,  labels = FALSE, hang = -1, main = "Original Tree")
plot(hc1, labels = FALSE, hang = -1, main = "Re-start from 10 clusters")
par(opar)


install.packages("PerformanceAnalytics")
install.packages("dtw")
library("PerformanceAnalytics")
my_data <- mtcars[, c(1,3,4,5,6,7)]
chart.Correlation(my_data, histogram=TRUE, pch=19)

sc <- read.table("C:/Users/cpatiljs/Downloads/synthetic_control.data", header=F, sep="")
#randomly sampled n cases from each class, to make it easy for plotting
n <- 10
s <- sample(1:100, n)
idx <- c(s, 100+s, 200+s, 300+s, 400+s, 500+s)
sample2 <- sc[idx,]
observedLabels <- c(rep(1,n), rep(2,n), rep(3,n), rep(4,n), rep(5,n), rep(6,n))
#compute DTW distances
library(dtw)
distMatrix <- dist(sample2, method="DTW")
#hierarchical clustering
hc <- hclust(distMatrix, method="average")
plot(hc, labels=observedLabels, main="")


# extracting DWT coefficients (with Haar filter)
install.packages("wavelets")
library(wavelets)
 wtData <- NULL
 for (i in 1:nrow(sc)) {
   a <- t(sc[i,])
   wt <- dwt(a, filter="haar", boundary="periodic")
   wtData <- rbind(wtData, unlist(c(wt@W,wt@V[[wt@level]])))
 }
 wtData <- as.data.frame(wtData)
 
# set class labels into categorical values
 classId <- c(rep("1",100), rep("2",100), rep("3",100),
   rep("4",100), rep("5",100), rep("6",100))
 wtSc <- data.frame(cbind(classId, wtData))
 
# build a decision tree with ctree() in package party
 library(party)
 ct <- ctree(classId ~ ., data=wtSc,
               controls = ctree_control(minsplit=30, minbucket=10, maxdepth=5))
 pClassId <- predict(ct)
 
# check predicted classes against original class labels
 table(classId, pClassId)
 (sum(classId==pClassId)) / nrow(wtSc)
 
 plot(ct, ip_args=list(pval=FALSE), ep_args=list(digits=0))
 
 
 
 
 
 
 
 
 
 unlist(options())
 unlist(options(), use.names = FALSE)
 
 l.ex <- list(a = list(1:5, LETTERS[1:5]), b = "Z", c = NA)
 unlist(l.ex, recursive = FALSE)
 unlist(l.ex, recursive = TRUE, use.names = T)
 
 l1 <- list(a = "a", b = 2, c = pi+2i)
 unlist(l1) # a character vector
 l2 <- list(a = "a", b = as.name("b"), c = pi+2i)
 unlist(l2) # remains a list
 
 ll <- list(as.name("sinc"), quote( a + b ), 1:10, letters, expression(1+x))
 utils::str(ll)
 for(x in ll)
   stopifnot(identical(x, unlist(x)))
 
 
 data <- c(runif(100000, min=0, max=.1),runif(100000, min=.05, max=.1),runif(10000, min=.05, max=1), runif(100000, min=0, max=.2))
 
 slideFunct <- function(data, window, step){
   total <- length(data)
   spots <- seq(from=1, to=(total-window), by=step)
   result <- vector(length = length(spots))
   for(i in 1:length(spots)){
     result[i] <- mean(data[spots[i]:(spots[i]+window)])
   }
   return(result)
 }
 
 window=10
 step=1
 j<- slideFunct(data, window, step)
 head(j)
 