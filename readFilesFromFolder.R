
#############

filePaths <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = TRUE, recursive = TRUE)
fileNames <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = FALSE, recursive = TRUE)
pf = lapply(filePaths,sep = ",", header = TRUE, row.names =1, read.delim)
dim(pf[[1]])
names(pf) <- fileNames


#################

pnames <- NULL
totala <- NULL
micv <- NULL
primv <- NULL
totalv <- NULL
primavg = NULL
tavg <- NULL

for (i in 1:length(names(pf))) {
  
  # make sure there are pee events
  if (dim(pf[[i]])[1] > 0) {
    
    # filter out very small area sizes
    filter <- which(pf[[i]][1] > 1500)
    
    # make a list of voids for file i
    fpf <- pf[[i]][filter,1]
    
    # check again for pee events after filtering
    if (length(fpf) > 0) {
 
      # count the number of total voids
      tempEvent <- length(fpf)
      totalv <- c(totalv, tempEvent)
      
      # count microvoids
      tempmic <- which(fpf < 20000)
      if (length(tempmic > 0)) {
        micv <- c(micv, length(tempmic))
      }
      else {
        micv <- c(micv, 0)
      }
      
      # count primaryvoids
      tempprim <- which(fpf >= 20000)
      if (length(tempprim > 0)) {
        primv <- c(primv, length(tempprim))
        pfpf <- fpf[tempprim]
        tempprimavg <- mean(pfpf)
        primavg <- c(primavg, tempprimavg)
        
      }
      else {
        primv <- c(primv, 0)
        primavg = c(primavg, 0)
      }

    # sum the total area of all pee events   
      tempa <- sum(fpf)
      totala <- c(totala, tempa)
      
    # calculate the mean of all voids
      tempavg <- mean(fpf)
      tavg <- c(tavg, tempavg)
    }
    
    else {
      totala <- c(totala, sum(fpf))
      totalv <- c(totalv,  length(fpf))
      micv <- c(micv, 0)
      primv <- c(primv, 0)
      tavg <- c(tavg, mean(fpf))
      primavg = c(primavg, 0)
      
    }
    
  }
  else {
    
    totala <- c(totala, 0)
    totalv <- c(totalv, 0)
    micv <- c(micv, 0)
    primv <- c(primv, 0)
    tavg <- c(tavg, 0)
    primavg = c(primavg, 0)
    
  } 
  
    
     
  tempName <- names(pf)[[i]]
  pnames <- c(pnames, tempName)
}
###################
#***

#**Part3**
  
  
  
 

pdata <- data.frame(File = pnames, Total_Area = totala, Total_Voids = totalv,
                    Primary_Voids = primv, Micro_Voids = micv, Primary_Mean = 
                      primavg, Total_Mean = tavg) 


write.table(pdata, "pSumsData.csv", sep = ",", row.names = FALSE)


#names(psums) <- pnames
#ordpsums <- order(psums)
#ordpsums <- psums[ordpsums]
#plot(ordpsums)
#psumsdata <- as.data.frame(ordpsums, 
#row.names = names(ordpsums))
#colnames(psumsdata)  <- "Ordered Pee Sums"


# Next: sum the number of pee events



# pool <- rbind(c(tempName, tempSum))



#fileNames <- substring(temp,0)
#names(myfiles) <- fileNames 