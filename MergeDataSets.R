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

source("overLapper.R")
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

oldies <- rownames(w150t)

old50 <- w50t[oldies,]
old100 <- w100t[oldies,]
old <- cbind(old50, old100, w150t)

med <- overLapper(list(med = rownames(w100t), old = oldies), type = "vennsets")
meds <- med$Venn_List$med
med100 <- w100t[meds,]
med50 <- w50t[meds,]

med <- cbind(med50, med100)

short <- overLapper(list(short = rownames(w50t), med = meds), type = "vennsets")
shorts <- short$Venn_List$short
short <- w50t[shorts,]



sct <- length(which(short$Group == "Ct"))
sr20 <- length(which(short$Group == "R20"))
sr40 <- length(which(short$Group == "R40"))
sd1 <- length(which(short$Group == "D1"))
sd2 <- length(which(short$Group == "D2"))
mct <-  length(which(med$Group == "Ct"))
mr20 <-  length(which(med$Group == "R20"))
mr40 <-  length(which(med$Group == "R40"))
md1 <-  length(which(med$Group == "D1"))
md2 <-  length(which(med$Group == "D2"))
oct <-  length(which(old$Group == "Ct"))
or20 <-  length(which(old$Group == "R20"))
or40 <-  length(which(old$Group == "R40"))
od1 <-  length(which(old$Group == "RD1"))
od2 <-  length(which(old$Group == "RD2"))


lifeByDietAge <- c(sct, mct, oct, sr20, mr20, or20, sr40, mr40, or40, sd1, md1, od1, sd2, md2, od2)

lifeByAgeDiet <- c(sct, sr20, sr40, sd1, sd2, mct, mr20, mr40, md1, md2, oct, or20, or40, od1, od2)

lifeByDiet <- c(sct, mct, oct, sr20, mr20, or20, sr40, mr40, or40, sd1, md1, od1, sd2, md2, od2)

barplot(lifeByDiet)

lifeByAgeDiet <- c(sct, sr20, sr40, sd1, sd2, mct, mr20, mr40, md1, md2, oct, or20, or40, od1, od2)
barplot(lifeByAgeDiet)

sl <- dim(short)[1]
ml <- dim(med)[1]
ol <- dim(old)[1]
lifeByAgePropDiet <- c(sct/sl, sr20/sl, sr40/sl, sd1/sl, sd2/sl, mct/ml, mr20/ml, mr40/ml, md1/ml, md2/ml, oct/ol, or20/ol, or40/ol, od1/ol, od2/ol)
barplot(lifeByAgePropDiet)

##################################################

colnames(short)
shortMic <- short[,5] * short[,6] + short[,12] * short[,13]
shortMic <- shortMic/sl
shortMic <- short[,5] * short[,6] + short[,12] * short[,13]
shortAvg <- sum(shortMic)/sl
shortAvg

medMic <- med[,19] * med[,20] + med[,26] * med[,27]

medAvg <- sum(medMic)/ml
medAvg
medAvg100<- medAvg


medMic50 <- na.omit(med[,5]) * na.omit(med[,6]) + na.omit(med[,12]) * na.omit(med[,13])
medAvg50 <- sum(medMic50)/length(medMic50)
medAvg50
medAvg100

oldMic50 <- na.omit(old[,5]) * na.omit(old[,6]) + na.omit(old[,12]) * na.omit(old[,13])
oldAvg50 <- sum(oldMic50)/length(oldMic50)
oldAvg50
oldMic100 <- na.omit(old[,19]) * na.omit(old[,20]) + na.omit(old[,26]) * na.omit(old[,27])
oldAvg100 <- sum(oldMic100)/length(oldMic100)
oldAvg100

oldMic150 <- na.omit(old[,33]) * na.omit(old[,34]) + na.omit(old[,40]) * na.omit(old[,41])
oldAvg150 <- sum(oldMic150)/length(oldMic150)
oldAvg150
medAvg100
shortAvg
medAvg50
oldAvg50


