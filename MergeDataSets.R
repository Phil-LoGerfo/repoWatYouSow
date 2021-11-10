w50d1 <- read.delim("50Wk1-JAX_2.txt", sep = "\t", row.names = 2)
w50d2 <- read.delim("50Wk2-JAX_2.txt", sep = "\t", row.names = 2)
w100d2 <- read.delim("100Wk2-JAX_2.txt", sep = "\t", row.names = 2)
w100d1 <- read.delim("100Wk1-JAX_2.txt", sep = "\t", row.names = 2)
w150d1 <- read.delim("150Wk1-JAX_2.txt", sep = "\t", row.names = 2)
w150d2 <- read.delim("150Wk2-JAX_2.txt", sep = "\t", row.names = 2)
# combine day 1 and 2 data sets, and remove imageNumber fields 
w150t <- cbind(w150d1[,2:8], w150d2[,2:8])
setlist <- list(A = rownames(w50d1), B =rownames(w50d2))
# check if dims are equal
dim(w50d2)
dim(w50d1)

# https://github.com/wjidea/Bac_Pan/blob/master/overLapper.R
ol50 <- overLapper(setlist, type="vennsets")
w50d1o <- w50d1[ol50$Venn_List$`A-B`,]
w50d2o <- w50d2[ol50$Venn_List$`A-B`,]
w50t <- cbind(w50d1o[,2:8], w50d2o[,2:8])


dim(w100d2)
dim(w100d1)

setlist <- list(A = rownames(w100d1), B =rownames(w100d2))
ol100 <- overLapper(setlist, type="vennsets")
w100d1o <- w100d1[ol100$Venn_List$`A-B`,]
w100d2o <- w100d2[ol100$Venn_List$`A-B`,]
w100t <- cbind(w100d1o[,2:8], w100d2o[,2:8])

