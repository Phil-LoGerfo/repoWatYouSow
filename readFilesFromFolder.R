
filePaths <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = TRUE, recursive = TRUE)
fileNames <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = FALSE, recursive = TRUE)
pf = lapply(filePaths,sep = ",", header = TRUE, row.names =1, read.delim)
dim(pf[[1]])
names(pf) <- fileNames


pnames <- NULL
psums <- NULL
pevents <- NULL
for (i in 1:length(names(pf))) {
  
  # make sure there are pee events
  if (dim(pf[[i]])[1] > 0) {
    
    # filter out small area sizes
    filter <- which(pf[[i]][1] > 1500)
    fpf <- pf[[i]][filter,1]
    
    # check again for pee events after filtering
    if (length(fpf) > 0) {
      # count the number of pee events
      tempEvent <- length(fpf)
      pevents <- c(pevents, tempEvent)
      # sum the total area of all pee events   
      tempSum <- sum(fpf)
      psums <- c(psums, tempSum)
    }
    
    else {
      psums <- c(psums, 0)
      pevents <- c(pevents, 0)
    }
    
  }

   
  else {
    psums <- c(psums, 0)
    pevents <- c(pevents, 0)
  } 
  
    tempName <- names(pf)[[i]]
    pnames <- c(pnames, tempName)
}     



#***

#Order, plot, write table of pee area sums from each file

 
pdata <- cbind(pnames, psums, pevents)   


#names(psums) <- pnames
#ordpsums <- order(psums)
#ordpsums <- psums[ordpsums]
#plot(ordpsums)
#psumsdata <- as.data.frame(ordpsums, 
#row.names = names(ordpsums))
#colnames(psumsdata)  <- "Ordered Pee Sums"
#write.table(psumsdata, "pSumsData.csv", sep = ",")

# Next: sum the number of pee events



 # pool <- rbind(c(tempName, tempSum))



#fileNames <- substring(temp,0)
#names(myfiles) <- fileNames 