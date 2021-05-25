

#### Read in the CSV and PNG file Names and Paths

pngPaths <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.png", full.names = TRUE, recursive = TRUE)
pngNames <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.png", full.names = FALSE, recursive = TRUE)


csvPaths <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = TRUE, recursive = TRUE)
csvNames <- dir(path ="~/Test_set_Lg/Test_Set_Lg", pattern = "*.csv", full.names = FALSE, recursive = TRUE)


########


base <- NULL
stdmm <- NULL
pvol <- NULL

for (i in 1:length(csvPaths)) {
  
  # Read in the PNG file that corresponds with the CSV file
  pp <- readPNG(pngPaths[i])
  # estimate the pixel area of the cage floor
  tempbase <- length(which(pp > .05))
  base <- c(base, tempbase)
  #convert pixels to area
  stdmm <- tempbase/(265*111)
  
  # Read in the CSV file 
  pf <- read.delim(csvPaths[i], sep = ",", header = TRUE, row.names = 1)
  
  # make sure there are pee events
  if (dim(pf[1]) > 0) {
    #calculate volume 
    pvol <- (pf[1]/stdmm)*0.283		
    pvol <- cbind(rownames(pf), pvol)
    colnames(pvol) <- c("ID","Volumes")
    newFileName <-  paste(substring(csvPaths[i],1, nchar(csvPaths[i])- 9 ), "Vols.csv", sep = "")
    write.table(pvol, newFileName , sep = ',', row.names = FALSE)
  }
  else {
    newFileName <- paste(substring(csvPaths[i],1, nchar(csvPaths[i])- 9 ), "Vols.csv", sep = "")
    write.table(pf, newFileName , sep = ',')
  }
}





