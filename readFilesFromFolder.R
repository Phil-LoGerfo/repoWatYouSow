
filePaths <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = TRUE, recursive = TRUE)
fileNames <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = FALSE, recursive = TRUE)
pf = lapply(filePaths,sep = ",", header = TRUE, row.names =1, read.delim)
dim(pf[[1]])
names(pf) <- fileNames

pool <- data.frame(name = NULL, sum = NULL)

pnames <- NULL
psums <- NULL
for (i in 1:length(names(pf))) {
  
  if (dim(pf[[i]])[1] > 0) {
    tempSum <- sum(pf[[i]][1])
    psums <- c(psums, tempSum)
  }
  
  else {
    psums <- c(psums, 0)
  } 
    tempName <- names(pf)[[i]]
    pnames <- c(pnames, tempName)
}     



#***

#Order, plot, write table of pee area sums from each file

 
   
names(psums) <- pnames
ordpsums <- order(psums)
ordpsums <- psums[ordpsums]
plot(ordpsums)
psumsdata <- as.data.frame(ordpsums, 
row.names = names(ordpsums))
colnames(psumsdata)  <- "Ordered Pee Sums"
write.table(psumsdata, "pSumsData.csv", sep = ",")

# Next: sum the number of pee events



 # pool <- rbind(c(tempName, tempSum))



#fileNames <- substring(temp,0)
#names(myfiles) <- fileNames 