 library(png)
 library(ggplot2)

 pngPaths <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.png", full.names = TRUE, recursive = TRUE)
 pngNames <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.png", full.names = FALSE, recursive = TRUE)
 #pp = lapply(pngPaths, readPNG)
 
  #########################
 
 filePaths <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = TRUE, recursive = TRUE)
 fileNames <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = FALSE, recursive = TRUE)
 #pf = lapply(filePaths,sep = ",", header = TRUE, row.names =1, read.delim)


base <- NULL
pnames <- NULL
totala <- NULL
micv <- NULL
primv <- NULL
totalv <- NULL
primavg = NULL
microavg = NULL
tavg <- NULL

for (i in 1:length(filePaths)) {
  
  # Read in the PNG file that corresponds with the CSV file
  pp <- readPNG(pngPaths[i])
  # estimate the pixel area of the cage floor
  tempbase <- length(which(pp > .05))
  base <- c(base, tempbase)
  
  # Read in the CSV file 
  pf <- read.delim(filePaths[i], sep = ",", header = TRUE, row.names = 1)
  
  # make sure there are pee events
  if (dim(pf[1]) > 0) {
    # make a list of unfiltered total voids
    tpf <- pf[1]
    # filter out very small area sizes
    filter <- which(pf[,1] > 1500)
    
    # make a list of voids for file i
    fpf <- pf[filter,1]
    
    # check again for pee events after filtering
    if (length(fpf) > 0) {
      
      # count the number of total voids
      tempEvent <- length(fpf)
      #add the total void count from that file to list totalv
      totalv <- c(totalv, tempEvent)
      
      # count microvoids
      tempmic <- which(fpf < 20000)
      if (length(tempmic > 0)) {
        # add the total micro void count to list microv
        micv <- c(micv, length(tempmic))
        # makes a list of micro voids only
        mfpf <- fpf[tempmic]
        # calculate the mean of micro voids
        tempmic <- mean(mfpf)
        # add the mean of micro voids to list microavg
        microavg <- c(microavg, tempmic)
      }
      else {
        # if there are no micro voids
        micv <- c(micv, 0)
        microavg = c(microavg, 0)
      }
      
      # count primaryvoids
      tempprim <- which(fpf >= 20000)
      if (length(tempprim > 0)) {
        # add the total primary void count to list primv
        primv <- c(primv, length(tempprim))
        # makes a list of primary voids only
        pfpf <- fpf[tempprim]
        # calculate the mean of primary voids
        tempprimavg <- mean(pfpf)
        # add the mean of primary voids to list primavg
        primavg <- c(primavg, tempprimavg)
        
      }
      else {
        # if there are no primary voids
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
      # If there are no micro or primary voids, but some voids < 1500 in area
      #   totala <- c(totala, sum(tpf))
      #  totalv <- c(totalv,  length(tpf))
      micv <- c(micv, 0)
      primv <- c(primv, 0)
      #    tavg <- c(tavg, mean(tpf))
      primavg = c(primavg, 0)
      microavg = c(microavg, 0)
      
      totala <- c(totala, 0)
      totalv <- c(totalv,  0)
      tavg <- c(tavg, 0)
      
    }
    
  }
  else {
    
    totala <- c(totala, 0)
    totalv <- c(totalv, 0)
    micv <- c(micv, 0)
    primv <- c(primv, 0)
    tavg <- c(tavg, 0)
    primavg = c(primavg, 0)
    microavg = c(microavg, 0)
    
  } 
  
  
  # Add the name of data file to list pnames   
  tempName <- fileNames[i]
  pnames <- c(pnames, tempName)
}
###################
#***

#**Part3**







pdata <- data.frame(row.names = pnames, Total_Area = totala, Total_Voids = totalv, Total_Mean = tavg,
                    Primary_Voids = primv, Primary_Mean = primavg, 
                    Micro_Voids = micv, Micro_Mean = microavg, base = base) 


write.table(pdata, "pSumsData.csv", sep = ",", row.names = TRUE)


pic <-ggplot(data.frame(Area= pdata$Total_Area, Voids=pdata$Total_Voids)) +
geom_point(aes(Area,Voids)) +
geom_smooth(mapping = aes(Area,Voids), method="lm", se=FALSE, color = "red")
plot(pic)
ggsave("AreaVoids.png")



#names(psums) <- pnames
#ordpsums <- order(psums)
#ordpsums <- psums[ordpsums]
#plot(ordpsums)
#psumsdata <- as.data.frame(ordpsums, 
#row.names = names(ordpsums))
#colnames(psumsdata)  <- "Ordered Pee Sums"


# Next: sum the number of pee events



# pool <- rbind(c(tempName, tempSum))
